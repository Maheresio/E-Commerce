import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_data_source.dart';
import '../../../cart/presentation/controller/cart_provider.dart';
import '../../presentation/controller/delivery_method/delivery_method_providers.dart';
import '../../presentation/controller/order/order_notifier.dart';
import '../../presentation/controller/shipping_address/shipping_address_providers.dart';
import '../../presentation/controller/visa_card/visa_card_notifier.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../data/models/visa_card_model.dart';
import 'checkout_exception_handler.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this.remoteDataSource, this.ref);
  final CheckoutRemoteDataSource remoteDataSource;
  final Ref ref;

  @override
  Future<Either<Failure, String>> processCheckout({
    required String userId,
    required double cartTotal,
    String? idempotencyKey,
  }) async => handleCheckoutExceptions(() async {
    // Get all required data
    final addresses = ref.read(shippingAddressNotifierProvider).valueOrNull;
    final selectedDeliveryMethod = ref.read(selectedDeliveryMethodProvider);
    final cartItems = ref.read(cartControllerProvider(userId)).valueOrNull;
    final cards = ref.read(visaCardNotifierProvider).valueOrNull ?? [];

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

    final defaultCard =
        cards.isNotEmpty
            ? cards.firstWhere(
              (c) => c.isDefault,
              orElse: () => cards.last as VisaCardModel,
            )
            : null;

    if (defaultCard == null) {
      throw const Failure('Please add a payment method first');
    }

    // Get customer ID
    final customerId =
        await ref.read(visaCardNotifierProvider.notifier).getOrCreateCustomer();

    // Get default address
    final defaultAddress = addresses.firstWhere(
      (addr) => addr.isDefault,
      orElse: () => addresses.first,
    );

    // Calculate total
    final totalAmount = cartTotal + selectedDeliveryMethod.cost;

    // Create order entity with deterministic ID
    final order = OrderEntity.createWithDeterministicId(
      userId: userId,
      totalAmount: totalAmount,
      quantity: cartItems.fold(0, (sum, item) => sum + item.quantity),
      cartItems: cartItems, // Use cart items directly
      shippingAddress: defaultAddress,
      paymentMethod: defaultCard,
      deliveryMethod: selectedDeliveryMethod,
      payment: PaymentEntity(
        id: 'payment_${DateTime.now().millisecondsSinceEpoch}',
        currency: 'usd',
        amount: totalAmount,
        paymentMethodId: defaultCard.id,
        status: PaymentStatus.processing,
        timestamp: DateTime.now(),
      ),
      idempotencyKey: idempotencyKey,
    );

    // Submit order with transaction protection and get client secret
    final clientSecret = await ref
        .read(orderNotifierProvider.notifier)
        .submitOrderWithTransaction(order, customerId, userId);

    return clientSecret;
  });

  @override
  Future<Either<Failure, void>> initializePaymentSheet({
    required String clientSecret,
    required String customerId,
    String? ephemeralKey,
    dynamic defaultCard,
    dynamic defaultAddress,
  }) async => handleCheckoutExceptions(() async {
    await remoteDataSource.initializePaymentSheet(
      clientSecret: clientSecret,
      customerId: customerId,
      ephemeralKey: ephemeralKey,
      defaultCard: defaultCard,
      defaultAddress: defaultAddress,
    );
  });

  @override
  Future<Either<Failure, void>> presentPaymentSheet() async =>
      handleCheckoutExceptions(() async {
        await remoteDataSource.presentPaymentSheet();
      });
}
