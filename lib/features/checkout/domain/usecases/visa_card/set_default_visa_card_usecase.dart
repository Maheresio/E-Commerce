import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/visa_card_repository.dart';

class SetDefaultVisaCardUseCase {
  SetDefaultVisaCardUseCase(this.repository);
  final VisaCardRepository repository;

  Future<Either<Failure, void>> execute({
    required String userId,
    required String paymentMethodId,
  }) => repository.setDefaultCard(
    customerId: userId,
    paymentMethodId: paymentMethodId,
  );
}
