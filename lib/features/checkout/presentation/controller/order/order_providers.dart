import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_services_provider.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../data/datasources/order_remote_data_source.dart';
import '../../../data/repositories/order_repository_impl.dart';
import '../../../domain/repositories/order_repository.dart';
import '../visa_card/visa_card_providers.dart';

final Provider<OrderRemoteDataSource> orderRemoteDataSourceProvider =
    Provider<OrderRemoteDataSource>((ref) {
      final FirestoreServices firestore = ref.read(firestoreServicesProvider);
      return OrderRemoteDataSourceImpl(
        firestore: firestore,
        dio: ref.read(dioClientProvider),
      );
    });

final Provider<OrderRepository> orderRepositoryProvider =
    Provider<OrderRepository>((ref) {
      final OrderRemoteDataSource remote = ref.read(
        orderRemoteDataSourceProvider,
      );
      return OrderRepositoryImpl(
        remote: remote,
        currentUserService: ref.read(currentUserServiceProvider),
      );
    });
