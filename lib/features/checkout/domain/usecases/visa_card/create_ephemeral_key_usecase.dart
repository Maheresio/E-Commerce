import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/visa_card_repository.dart';

class CreateEphemeralKeyUsecase {
  CreateEphemeralKeyUsecase(this.repository);
  final VisaCardRepository repository;

  Future<Either<Failure, String>> execute(String customerId) =>
      repository.createEphemeralKey(customerId);
}
