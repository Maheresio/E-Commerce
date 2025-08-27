import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/visa_card_entity.dart';
import '../../repositories/visa_card_repository.dart';

class AddVisaCardUseCase {
  AddVisaCardUseCase(this.repository);
  final VisaCardRepository repository;

  Future<Either<Failure, String>> execute({
    required String customerId,
    required String cardToken,
    required VisaCardEntity card,
  }) => repository.addCard(
    customerId: customerId,
    cardToken: cardToken,
    card: card,
  );
}
