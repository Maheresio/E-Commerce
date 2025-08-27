import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/current_user_service.dart';
import '../../../../../core/services/firestore_services_provider.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../data/datasources/shipping_address_remote_data_source.dart';
import '../../../data/repositories/shipping_address_repository.dart';
import '../../../domain/entities/shipping_address_entity.dart';
import '../../../domain/repositories/shipping_address_repository.dart';
import 'shipping_address_notifier.dart';

final Provider<ShippingAddressRemoteDataSource>
shippingAddressRemoteDataSourceProvider =
    Provider<ShippingAddressRemoteDataSource>((ref) {
      final FirestoreServices firestore = ref.read(firestoreServicesProvider);
      return ShippingAddressRemoteDataSourceImpl(firestore);
    });
final Provider<ShippingAddressRepository> shippingAddressRepositoryProvider =
    Provider<ShippingAddressRepository>((ref) {
      final ShippingAddressRemoteDataSource remote = ref.read(
        shippingAddressRemoteDataSourceProvider,
      );
      final currentUserService = sl<CurrentUserService>();
      return ShippingAddressRepositoryImpl(remote, currentUserService);
    });

final shippingAddressNotifierProvider = NotifierProvider<
  ShippingAddressNotifier,
  AsyncValue<List<ShippingAddressEntity>>
>(ShippingAddressNotifier.new);

final StateProvider<bool> shippingAddressLoadingProvider = StateProvider<bool>(
  (ref) => false,
);
