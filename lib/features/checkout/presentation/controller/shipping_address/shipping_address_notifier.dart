import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/shipping_address_entity.dart';
import 'shipping_address_actions.dart';

class ShippingAddressNotifier
    extends Notifier<AsyncValue<List<ShippingAddressEntity>>> {
  late final ShippingAddressActions _actions;

  @override
  AsyncValue<List<ShippingAddressEntity>> build() {
    _actions = ShippingAddressActions(ref);
    _load();
    return const AsyncLoading();
  }

  Future<void> _load() async {
    state = await _actions.loadAddresses();
  }

  Future<void> refresh() async => _load();

  Future<void> addAddress(ShippingAddressEntity address) async {
    await _actions.addAddress(address);
    await refresh();
  }

  Future<void> updateAddress(ShippingAddressEntity address) async {
    await _actions.updateAddress(address);
    await refresh();
  }

  Future<void> deleteAddress(String id) async {
    await _actions.deleteAddress(id);
    await refresh();
  }

  Future<void> setDefault(String id) async {
    await _actions.setDefaultAddress(id);
    await refresh();
  }

  ShippingAddressEntity? getDefaultAddress() {
    final List<ShippingAddressEntity>? addresses = state.value;
    if (addresses == null) return null;
    try {
      return addresses.firstWhere(
        (ShippingAddressEntity addr) => addr.isDefault,
      );
    } catch (_) {
      return null;
    }
  }
}
