import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/visa_card_entity.dart';

abstract class VisaCardRepository {
  Future<Either<Failure, List<VisaCardEntity>>> getSavedCards();
  Future<Either<Failure, String>> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardEntity card,
  });
  Future<Either<Failure, void>> deleteCard({
    required String userId,
    required String paymentMethodId,
  });
  Future<Either<Failure, void>> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
  });

  Future<Either<Failure, String>> getOrCreateCustomer();
  Future<Either<Failure, String>> createEphemeralKey(String customerId);
}
