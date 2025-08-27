import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/visa_card_repository.dart';

class GetOrCreateCustomerUsecase {
  GetOrCreateCustomerUsecase(this.repository);
  final VisaCardRepository repository;

  Future<Either<Failure, String>> execute() => repository.getOrCreateCustomer();
}
