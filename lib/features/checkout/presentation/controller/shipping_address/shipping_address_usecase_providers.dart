import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/repositories/shipping_address_repository.dart';
import '../../../domain/usecases/shipping_address/add_shipping_address_usecase.dart';
import '../../../domain/usecases/shipping_address/delete_shipping_address_usecase.dart';
import '../../../domain/usecases/shipping_address/get_shipping_adresses_usecase.dart';
import '../../../domain/usecases/shipping_address/set_default_shipping_address_usecase.dart';
import '../../../domain/usecases/shipping_address/update_shopping_address_usecase.dart';
import 'shipping_address_providers.dart';

final Provider<GetShippingAddressesUseCase>
getShippingAddressesUseCaseProvider = Provider<GetShippingAddressesUseCase>((
  ref,
) {
  final ShippingAddressRepository repo = ref.read(
    shippingAddressRepositoryProvider,
  );
  return GetShippingAddressesUseCase(repo);
});

final Provider<AddShippingAddressUseCase> addShippingAddressUseCaseProvider =
    Provider<AddShippingAddressUseCase>((ref) {
      final ShippingAddressRepository repo = ref.read(
        shippingAddressRepositoryProvider,
      );
      return AddShippingAddressUseCase(repo);
    });

final Provider<DeleteShippingAddressUseCase>
deleteShippingAddressUseCaseProvider = Provider<DeleteShippingAddressUseCase>((
  ref,
) {
  final ShippingAddressRepository repo = ref.read(
    shippingAddressRepositoryProvider,
  );
  return DeleteShippingAddressUseCase(repo);
});

final Provider<UpdateShippingAddressUseCase>
updateShippingAddressUseCaseProvider = Provider<UpdateShippingAddressUseCase>((
  ref,
) {
  final ShippingAddressRepository repo = ref.read(
    shippingAddressRepositoryProvider,
  );
  return UpdateShippingAddressUseCase(repo);
});

final Provider<SetDefaultShippingAddressUseCase>
setDefaultShippingAddressUseCaseProvider =
    Provider<SetDefaultShippingAddressUseCase>((ref) {
      final ShippingAddressRepository repo = ref.read(
        shippingAddressRepositoryProvider,
      );
      return SetDefaultShippingAddressUseCase(repo);
    });
