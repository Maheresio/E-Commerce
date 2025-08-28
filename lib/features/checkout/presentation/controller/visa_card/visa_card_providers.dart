import '../../../../../core/services/firestore_services_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/services/current_user_service.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/services/firestore_sevice.dart';
import '../../../data/datasources/visa_card_remote_data_source.dart';
import '../../../data/repositories/visa_card_repository_impl.dart';
import '../../../domain/repositories/visa_card_repository.dart';

final Provider<DioClient> dioClientProvider = Provider<DioClient>(
  (ref) => DioClient(),
);

/// 🔌 Current User Service Provider
final Provider<CurrentUserService> currentUserServiceProvider =
    Provider<CurrentUserService>((ref) => sl<CurrentUserService>());

/// 🔌 Data Source Provider
final Provider<VisaCardRemoteDataSource> visaCardRemoteDataSourceProvider =
    Provider<VisaCardRemoteDataSource>((ref) {
      final DioClient dioClient = ref.read(dioClientProvider);
      final FirestoreServices firestore = ref.read(firestoreServicesProvider);
      final CurrentUserService currentUserService = ref.read(
        currentUserServiceProvider,
      );

      return VisaCardRemoteDataSourceImpl(
        dio: dioClient,
        firestore: firestore,
        currentUserService: currentUserService,
      );
    });

/// 📦 Repository Provider
final Provider<VisaCardRepository> visaCardRepositoryProvider =
    Provider<VisaCardRepository>((ref) {
      final VisaCardRemoteDataSource remote = ref.read(
        visaCardRemoteDataSourceProvider,
      );
      final currentUserService = sl<CurrentUserService>();
      return VisaCardRepositoryImpl(remote, currentUserService);
    });
