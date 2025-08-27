import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_services_provider.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../data/datasources/delivery_method_remote_data_source.dart';
import '../../../data/repositories/delivery_method_repository_impl.dart';
import '../../../domain/entities/delivery_method_entity.dart';
import '../../../domain/repositories/delivery_method_repository.dart';
import 'delivery_method_notifier.dart';

final Provider<DeliveryMethodRemoteDataSource>
deliveryMethodRemoteDataSourceProvider =
    Provider<DeliveryMethodRemoteDataSource>((ref) {
      final FirestoreServices firestore = ref.read(firestoreServicesProvider);
      return DeliveryMethodRemoteDataSourceImpl(firestore);
    });

final Provider<DeliveryMethodRepository> deliveryMethodRepositoryProvider =
    Provider<DeliveryMethodRepository>((ref) {
      final DeliveryMethodRemoteDataSource remote = ref.read(
        deliveryMethodRemoteDataSourceProvider,
      );
      return DeliveryMethodRepositoryImpl(remote);
    });

final deliveryMethodNotifierProvider = NotifierProvider<
  DeliveryMethodNotifier,
  AsyncValue<List<DeliveryMethodEntity>>
>(DeliveryMethodNotifier.new);

final StateProvider<DeliveryMethodEntity?> selectedDeliveryMethodProvider =
    StateProvider<DeliveryMethodEntity?>(
      (ref) => ref.watch(deliveryMethodNotifierProvider).value?.first,
    );
