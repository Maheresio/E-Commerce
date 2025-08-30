import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/visa_card_entity.dart';
import 'visa_card_actions.dart';

class VisaCardNotifier extends Notifier<AsyncValue<List<VisaCardEntity>>> {
  late final VisaCardActions _actions;

  @override
  AsyncValue<List<VisaCardEntity>> build() {
    _actions = VisaCardActions(ref);
    _load();
    return const AsyncLoading();
  }

  Future<void> _load() async {
    state = await _actions.loadCards();
  }

  Future<void> refresh() async => _load();

  Future<String> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardEntity card,
  }) async => await _actions.addCard(
    customerId: customerId,
    cardToken: cardToken,
    card: card,
    setState: (setState) => state = setState,
  );

  Future<void> deleteCard({
    required String userId,
    required String paymentMethodId,
  }) async {
    await _actions.deleteCard(
      userId: userId,
      paymentMethodId: paymentMethodId,
      setState: (AsyncValue<List<VisaCardEntity>> setState) => state = setState,
    );
  }

  Future<void> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
  }) async {
    ref.read(visaCardLoadingState.notifier).state = true;
    await _actions.setDefaultCard(
      customerId: customerId,
      paymentMethodId: paymentMethodId,
      setState: (AsyncValue<List<VisaCardEntity>> setState) => state = setState,
    );
    ref.read(visaCardLoadingState.notifier).state = false;
  }

  VisaCardEntity? getDefaultCard() {
    try {
      return state.value?.firstWhere((VisaCardEntity card) => card.isDefault);
    } catch (e) {
      return null;
    }
  }

  Future<String> getOrCreateCustomer() async =>
      await _actions.getOrCreateCustomer((setState) => state = setState);

  Future<Either<Failure, String>> createEphemeralKey(String customerId) async =>
      await _actions.createEphemeralKey(customerId);

  Future<void> deleteAllCards(String userId) async {
    final List<VisaCardEntity> currentCards =
        state.valueOrNull ?? <VisaCardEntity>[];

    if (currentCards.isEmpty) {
      return;
    }

    // Delete each card one by one
    for (final VisaCardEntity card in currentCards) {
      await deleteCard(userId: userId, paymentMethodId: card.id);
    }
    await refresh();
  }
}

final visaCardNotifierProvider =
    NotifierProvider<VisaCardNotifier, AsyncValue<List<VisaCardEntity>>>(
      VisaCardNotifier.new,
    );

final StateProvider<bool> visaCardLoadingState = StateProvider((ref) => false);
