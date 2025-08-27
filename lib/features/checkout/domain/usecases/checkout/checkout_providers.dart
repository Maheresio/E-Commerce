import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/checkout_remote_data_source.dart';
import '../../../data/repositories/checkout_repository_impl.dart';
import '../../repositories/checkout_repository.dart';
import 'initialize_payment_sheet_usecase.dart';
import 'present_payment_sheet_usecase.dart';
import 'process_checkout_usecase.dart';

// Data Source
final Provider<CheckoutRemoteDataSource> checkoutRemoteDataSourceProvider =
    Provider<CheckoutRemoteDataSource>((ref) => CheckoutRemoteDataSourceImpl());

// Repository
final Provider<CheckoutRepository> checkoutRepositoryProvider =
    Provider<CheckoutRepository>((ref) {
      final CheckoutRemoteDataSource remoteDataSource = ref.watch(
        checkoutRemoteDataSourceProvider,
      );
      return CheckoutRepositoryImpl(remoteDataSource, ref);
    });

// Use Cases
final Provider<ProcessCheckoutUsecase> processCheckoutUsecaseProvider =
    Provider<ProcessCheckoutUsecase>((ref) {
      final CheckoutRepository repository = ref.watch(
        checkoutRepositoryProvider,
      );
      return ProcessCheckoutUsecase(repository);
    });

final Provider<InitializePaymentSheetUsecase>
initializePaymentSheetUsecaseProvider = Provider<InitializePaymentSheetUsecase>(
  (ref) {
    final CheckoutRepository repository = ref.watch(checkoutRepositoryProvider);
    return InitializePaymentSheetUsecase(repository);
  },
);

final Provider<PresentPaymentSheetUsecase> presentPaymentSheetUsecaseProvider =
    Provider<PresentPaymentSheetUsecase>((ref) {
      final CheckoutRepository repository = ref.watch(
        checkoutRepositoryProvider,
      );
      return PresentPaymentSheetUsecase(repository);
    });
