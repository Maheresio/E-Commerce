import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/visa_card_entity.dart';
import 'visa_card_notifier.dart';
import 'visa_card_usecases_providers.dart';

typedef UpdateState<T> = void Function(AsyncValue<T>);

class VisaCardActions {
  VisaCardActions(this.ref);
  final Ref ref;

  Future<AsyncValue<List<VisaCardEntity>>> loadCards() async {
    final Either<Failure, List<VisaCardEntity>> result = await ref.read(getVisaCardsUseCaseProvider).execute();
    return result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }

  Future<String> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardEntity card,
    required UpdateState<List<VisaCardEntity>> setState,
  }) async {
    final Either<Failure, String> result = await ref
        .read(addVisaCardUseCaseProvider)
        .execute(customerId: customerId, cardToken: cardToken, card: card);
    await _handleResult(result, setState);
    return result.fold(
      (Failure failure) => failure.message,
      (String paymentMethod) => paymentMethod,
    );
  }

  Future<void> deleteCard({
    required String userId,
    required String paymentMethodId,
    required UpdateState<List<VisaCardEntity>> setState,
  }) async {
    ref.read(visaCardLoadingState.notifier).state = true;
    final Either<Failure, void> result = await ref
        .read(deleteVisaCardUseCaseProvider)
        .execute(userId: userId, paymentMethodId: paymentMethodId);
    await _handleResult(result, setState);
        ref.read(visaCardLoadingState.notifier).state = false;

  }

  Future<void> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
    required UpdateState<List<VisaCardEntity>> setState,
  }) async {
    final Either<Failure, void> result = await ref
        .read(setDefaultVisaCardUseCaseProvider)
        .execute(userId: customerId, paymentMethodId: paymentMethodId);
    await _handleResult(result, setState);
  }

  Future<String> getOrCreateCustomer(
    UpdateState<List<VisaCardEntity>> setState,
  ) async {
    final Either<Failure, String> result = await ref.read(getOrCreateCustomerUseCaseProvider).execute();
    return result.fold((Failure failure) => '', (String data) => data);
  }

  Future<Either<Failure, String>> createEphemeralKey(String customerId) async {
    final Either<Failure, String> result = await ref
        .read(createEphemeralKeyUseCaseProvider)
        .execute(customerId);
    return result;
  }

  Future<void> _handleResult(
    Either<Failure, void> result,
    UpdateState<List<VisaCardEntity>> setState,
  ) async {
    result.fold(
      (Failure failure) => setState(AsyncError(failure.message, StackTrace.current)),
      (_) async {
        final AsyncValue<List<VisaCardEntity>> refreshed = await loadCards();
        setState(refreshed);
      },
    );
  }
}
