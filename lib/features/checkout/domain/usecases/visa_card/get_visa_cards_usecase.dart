import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/visa_card_entity.dart';
import '../../repositories/visa_card_repository.dart';

class GetVisaCardsUseCase {
  GetVisaCardsUseCase(this.repository);
  final VisaCardRepository repository;

  Future<Either<Failure, List<VisaCardEntity>>> execute() =>
      repository.getSavedCards();
}
