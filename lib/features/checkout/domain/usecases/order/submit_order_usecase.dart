import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../data/models/visa_card_model.dart';

import '../../entities/order_entity.dart';
import '../../entities/visa_card_entity.dart';
import '../../repositories/order_repository.dart';
import '../../repositories/visa_card_repository.dart';

class SubmitOrderUseCase {
  SubmitOrderUseCase({required this.orderRepo, required this.cardRepo});
  final OrderRepository orderRepo;
  final VisaCardRepository cardRepo;

  /// Saves the order in Firestore, creates a PaymentIntent,
  /// and returns a clientSecret for PaymentSheet.
  ///
  /// If the user has no saved cards, paymentMethodId will be null
  /// and Stripe PaymentSheet will show full card entry.
  Future<Either<Failure, String>> execute(
    OrderEntity order,
    String customerId,
    String userId,
  ) async {
    // 1. Get user's saved cards
    final Either<Failure, List<VisaCardEntity>> cardsResult =
        await cardRepo.getSavedCards();

    return cardsResult.fold(Left.new, (List<VisaCardEntity> cards) async {
      // 2. Determine paymentMethodId
      String? paymentMethodId;

      if (cards.isNotEmpty) {
        final VisaCardEntity defaultCard = cards.firstWhere(
          (VisaCardEntity c) => c.isDefault,
          orElse: () => cards.last as VisaCardModel,
        );
        paymentMethodId = defaultCard.id; // Stripe pm_xxx
      } else {
        paymentMethodId = null; // fallback → PaymentSheet will prompt new card
      }

      // 3. Submit order (repository handles Firestore + PaymentIntent)
      return orderRepo.submitOrder(
        order,
        customerId,
        paymentMethodId: paymentMethodId,
      );
    });
  }

  /// Transaction-based order submission with duplication prevention
  Future<Either<Failure, String>> executeWithTransaction(
    OrderEntity order,
    String customerId,
    String userId,
  ) async {
    // 1. Get user's saved cards
    final Either<Failure, List<VisaCardEntity>> cardsResult =
        await cardRepo.getSavedCards();

    return cardsResult.fold(Left.new, (List<VisaCardEntity> cards) async {
      // 2. Determine paymentMethodId
      String? paymentMethodId;

      if (cards.isNotEmpty) {
        final VisaCardEntity defaultCard = cards.firstWhere(
          (VisaCardEntity c) => c.isDefault,
          orElse: () => cards.last as VisaCardModel,
        );
        paymentMethodId = defaultCard.id; // Stripe pm_xxx
      } else {
        paymentMethodId = null; // fallback → PaymentSheet will prompt new card
      }

      // 3. Submit order with transaction protection
      return orderRepo.submitOrderWithTransaction(
        order,
        customerId,
        paymentMethodId: paymentMethodId,
      );
    });
  }
}
