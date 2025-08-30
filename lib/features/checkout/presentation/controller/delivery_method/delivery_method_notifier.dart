import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/delivery_method_entity.dart';
import 'delivery_method_actions.dart';

class DeliveryMethodNotifier
    extends Notifier<AsyncValue<List<DeliveryMethodEntity>>> {
  late final DeliveryMethodActions _actions;

  @override
  AsyncValue<List<DeliveryMethodEntity>> build() {
    _actions = DeliveryMethodActions(ref);
    _load();
    return const AsyncLoading();
  }

  Future<void> _load() async {
    state = await _actions.loadDeliveryMethods();
  }

  Future<void> refresh() async => _load();

  DeliveryMethodEntity? getDefaultMethod() {
    try {
      return state.value?.firstWhere(
        (DeliveryMethodEntity method) => method.isDefault,
      );
    } catch (e) {
      return null;
    }
  }
}

final deliveryMethodNotifierProvider = NotifierProvider<
  DeliveryMethodNotifier,
  AsyncValue<List<DeliveryMethodEntity>>
>(DeliveryMethodNotifier.new);
