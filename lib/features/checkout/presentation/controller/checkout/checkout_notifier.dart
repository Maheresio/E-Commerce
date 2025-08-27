import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cart/domain/entities/cart_item_entity.dart';
import '../../../../cart/presentation/controller/cart_provider.dart';
import '../../../data/models/visa_card_model.dart';
import '../../../domain/entities/delivery_method_entity.dart';
import '../../../domain/entities/visa_card_entity.dart';
import '../../../domain/usecases/checkout/checkout_providers.dart';
import '../../../domain/entities/order_entity.dart';
import '../../../domain/entities/payment_entity.dart';
import '../../../domain/entities/shipping_address_entity.dart';
import '../../../../../core/error/failure.dart';
import '../shipping_address/shipping_address_providers.dart';
import '../visa_card/visa_card_notifier.dart';
import '../delivery_method/delivery_method_providers.dart';
import '../order/order_usecase_providers.dart';

class CheckoutData {
  CheckoutData({
    required this.userId,
    required this.cartTotal,
    this.idempotencyKey,
  });
  final String userId;
  final double cartTotal;
  final String? idempotencyKey;
}

class CheckoutNotifier extends Notifier<AsyncValue<String>> {
  @override
  AsyncValue<String> build() => const AsyncData('');

  /// Process complete checkout flow with proper state management
  Future<void> processCompleteCheckout(CheckoutData data) async {
    state = const AsyncLoading();

    OrderEntity? orderToSave;

    try {
      // Step 1: Create order entity (but don't save to Firestore yet)
      orderToSave = await _createOrderEntity(data);

      // Step 2: Create PaymentIntent WITHOUT saving order to Firestore
      final Either<Failure, String> paymentIntentResult = await ref
          .read(createPaymentIntentUseCaseProvider)
          .execute(
            orderToSave,
            await _getCustomerId(),
            await _getPaymentMethodId(),
          );

      final String clientSecret = paymentIntentResult.fold(
        (Failure failure) => throw failure,
        (String secret) => secret,
      );

      // Step 3: Get customer ID for Stripe
      final String customerId = await _getCustomerId();

      // Step 4: Get saved cards and default card info
      final List<VisaCardEntity> cards =
          ref.read(visaCardNotifierProvider).valueOrNull ?? <VisaCardEntity>[];
      final VisaCardModel? defaultCard = _getDefaultCard(cards);

      // Step 5: Get default shipping address
      final ShippingAddressEntity? defaultAddress = _getDefaultAddress();

      // Step 6: Get ephemeral key for saved payment methods
      String? ephemeralKey;
      if (defaultCard != null) {
        final Either<Failure, String> ephemeralKeyResult = await ref
            .read(visaCardNotifierProvider.notifier)
            .createEphemeralKey(customerId);

        ephemeralKey = ephemeralKeyResult.fold(
          (Failure failure) => null,
          (String key) => key,
        );
      }

      // Step 7: Initialize payment sheet
      final Either<Failure, void> initResult = await ref
          .read(initializePaymentSheetUsecaseProvider)
          .execute(
            clientSecret: clientSecret,
            customerId: customerId,
            ephemeralKey: ephemeralKey,
            defaultCard: defaultCard,
            defaultAddress: defaultAddress,
          );

      initResult.fold(
        (Failure failure) => throw failure,
        (_) => <dynamic, dynamic>{},
      );

      // Step 8: Present payment sheet
      final Either<Failure, void> presentResult =
          await ref.read(presentPaymentSheetUsecaseProvider).execute();

      presentResult.fold(
        (Failure failure) => throw failure,
        (_) => <dynamic, dynamic>{},
      );

      // Step 9: ONLY save order to Firestore after successful payment
      final Either<Failure, void> saveOrderResult = await ref
          .read(saveOrderAfterPaymentUseCaseProvider)
          .execute(orderToSave);

      saveOrderResult.fold(
        (Failure failure) => throw failure,
        (_) => <dynamic, dynamic>{},
      );

      // Step 10: Clear cart after successful payment and order save
      clearCart(data.userId);

      state = const AsyncData('success');
    } catch (e) {
      // If payment failed or was cancelled, don't save the order
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  /// Create order entity with all necessary data
  Future<OrderEntity> _createOrderEntity(CheckoutData data) async {
    // Get all required data
    final List<ShippingAddressEntity>? addresses =
        ref.read(shippingAddressNotifierProvider).valueOrNull;
    final DeliveryMethodEntity? selectedDeliveryMethod = ref.read(
      selectedDeliveryMethodProvider,
    );
    final List<CartItemEntity>? cartItems =
        ref.read(cartControllerProvider(data.userId)).valueOrNull;
    final List<VisaCardEntity> cards =
        ref.read(visaCardNotifierProvider).valueOrNull ?? <VisaCardEntity>[];

    // Validate all required data
    if (addresses == null || addresses.isEmpty) {
      throw const Failure('Please add a shipping address first');
    }

    if (selectedDeliveryMethod == null) {
      throw const Failure('Please select a delivery method');
    }

    if (cartItems == null || cartItems.isEmpty) {
      throw const Failure('Your cart is empty');
    }

    final VisaCardModel? defaultCard = _getDefaultCard(cards);
    if (defaultCard == null) {
      throw const Failure('Please add a payment method first');
    }

    // Get default address
    final ShippingAddressEntity defaultAddress = addresses.firstWhere(
      (ShippingAddressEntity addr) => addr.isDefault,
      orElse: () => addresses.first,
    );

    // Calculate total
    final double totalAmount = data.cartTotal + selectedDeliveryMethod.cost;

    // Create order entity with deterministic ID
    return OrderEntity.createWithDeterministicId(
      userId: data.userId,
      totalAmount: totalAmount,
      quantity: cartItems.fold(
        0,
        (int sum, CartItemEntity item) => sum + item.quantity,
      ),
      cartItems: cartItems, // Use cart items directly
      shippingAddress: defaultAddress,
      paymentMethod: defaultCard,
      deliveryMethod: selectedDeliveryMethod,
      payment: PaymentEntity(
        id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
        currency: 'usd',
        amount: totalAmount,
        paymentMethodId: defaultCard.id,
        status: PaymentStatus.processing, // Start as processing
        timestamp: DateTime.now(),
      ),
      idempotencyKey: data.idempotencyKey,
    );
  }

  /// Get customer ID for Stripe
  Future<String> _getCustomerId() async =>
      await ref.read(visaCardNotifierProvider.notifier).getOrCreateCustomer();

  /// Get default payment method ID
  Future<String?> _getPaymentMethodId() async {
    final List<VisaCardEntity> cards =
        ref.read(visaCardNotifierProvider).valueOrNull ?? <VisaCardEntity>[];
    if (cards.isEmpty) return null;

    final VisaCardModel? defaultCard = _getDefaultCard(cards);
    return defaultCard?.id;
  }

  /// Get default card from list
  VisaCardModel? _getDefaultCard(List<dynamic> cards) {
    if (cards.isEmpty) return null;

    return cards.firstWhere(
      (c) => c.isDefault,
      orElse: () => cards.last as VisaCardModel,
    );
  }

  /// Get default shipping address
  ShippingAddressEntity? _getDefaultAddress() {
    final List<ShippingAddressEntity>? addresses =
        ref.read(shippingAddressNotifierProvider).valueOrNull;
    if (addresses?.isEmpty != false) return null;

    return addresses!.firstWhere(
      (ShippingAddressEntity addr) => addr.isDefault,
      orElse: () => addresses.first,
    );
  }

  void clearCart(String userId) {
    ref.read(cartControllerProvider(userId).notifier).clear();
  }
}

final checkoutNotifierProvider =
    NotifierProvider<CheckoutNotifier, AsyncValue<String>>(
      CheckoutNotifier.new,
    );
