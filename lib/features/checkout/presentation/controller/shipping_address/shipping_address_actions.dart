import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/shipping_address_entity.dart';
import 'shipping_address_providers.dart';
import 'shipping_address_usecase_providers.dart';

typedef EitherFailureOr<T> = Either<Failure, T>;
typedef UpdateState<T> = void Function(AsyncValue<T> newState);

class ShippingAddressActions {
  ShippingAddressActions(this.ref);
  final Ref ref;

  Future<AsyncValue<List<ShippingAddressEntity>>> loadAddresses() async {
    final Either<Failure, List<ShippingAddressEntity>> result =
        await ref.read(getShippingAddressesUseCaseProvider).execute();
    return result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }

  void shippingAddressLoadingToggle(bool loading) {
    ref.read(shippingAddressLoadingProvider.notifier).state = loading;
  }

  Future<void> addAddress(ShippingAddressEntity address) async {
    shippingAddressLoadingToggle(true);
    final Either<Failure, void> result = await ref
        .read(addShippingAddressUseCaseProvider)
        .execute(address);
    await setDefaultAddress(address.id);
    await _handleResult(result);
    shippingAddressLoadingToggle(false);
  }

  Future<void> updateAddress(ShippingAddressEntity address) async {
    shippingAddressLoadingToggle(true);
    final Either<Failure, void> result = await ref
        .read(updateShippingAddressUseCaseProvider)
        .execute(address);
    await _handleResult(result);
    shippingAddressLoadingToggle(false);
  }

  Future<void> deleteAddress(String addressId) async {
    final Either<Failure, void> result = await ref
        .read(deleteShippingAddressUseCaseProvider)
        .execute(addressId);
    await _handleResult(result);
  }

  Future<void> setDefaultAddress(String addressId) async {
    shippingAddressLoadingToggle(true);

    final Either<Failure, void> result = await ref
        .read(setDefaultShippingAddressUseCaseProvider)
        .execute(addressId);
    await _handleResult(result);
    shippingAddressLoadingToggle(false);
  }

  Future<AsyncValue<List<ShippingAddressEntity>>> _handleResult(
    EitherFailureOr<void> result,
  ) async => await result.fold(
    (failure) => AsyncError(failure.message, StackTrace.current),
    (_) => loadAddresses(),
  );
}
