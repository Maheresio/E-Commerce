import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../../../core/services/current_user_service.dart';
import '../../domain/entities/visa_card_entity.dart';
import '../../domain/repositories/visa_card_repository.dart';
import '../datasources/visa_card_remote_data_source.dart';
import '../models/visa_card_model.dart';

class VisaCardRepositoryImpl implements VisaCardRepository {
  VisaCardRepositoryImpl(this.remoteDataSource, this.currentUserService);
  final VisaCardRemoteDataSource remoteDataSource;
  final CurrentUserService currentUserService;

  @override
  Future<Either<Failure, List<VisaCardEntity>>> getSavedCards() async =>
      handleRepositoryExceptions(() async {
        final userId = currentUserService.currentUserId;
        if (userId == null) throw Exception('User not logged in');
        final cards = await remoteDataSource.getSavedCards(userId);
        return cards;
      });

  @override
  Future<Either<Failure, String>> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardEntity card,
  }) async => handleRepositoryExceptions(() async {
    final cardId = await remoteDataSource.addCard(
      customerId: customerId,
      cardToken: cardToken,
      card: VisaCardModel.fromEntity(card),
    );
    return cardId;
  });

  @override
  Future<Either<Failure, void>> deleteCard({
    required String userId,
    required String paymentMethodId,
  }) async => handleRepositoryExceptions(() async {
    await remoteDataSource.deleteCard(
      userId: userId,
      paymentMethodId: paymentMethodId,
    );
  });

  @override
  Future<Either<Failure, void>> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
  }) async => handleRepositoryExceptions(() async {
    await remoteDataSource.setDefaultCard(
      customerId: customerId,
      paymentMethodId: paymentMethodId,
    );
  });

  @override
  Future<Either<Failure, String>> getOrCreateCustomer() =>
      handleRepositoryExceptions(() async {
        return await remoteDataSource.getOrCreateCustomer();
      });

  @override
  Future<Either<Failure, String>> createEphemeralKey(String customerId) =>
      handleRepositoryExceptions(() async {
        return await remoteDataSource.createEphemeralKey(customerId);
      });
}
