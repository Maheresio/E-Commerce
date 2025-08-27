import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/checkout_repository.dart';

class InitializePaymentSheetUsecase {
  InitializePaymentSheetUsecase(this.repository);
  final CheckoutRepository repository;

  Future<Either<Failure, void>> execute({
    required String clientSecret,
    required String customerId,
    String? ephemeralKey,
    dynamic defaultCard,
    dynamic defaultAddress,
  }) => repository.initializePaymentSheet(
    clientSecret: clientSecret,
    customerId: customerId,
    ephemeralKey: ephemeralKey,
    defaultCard: defaultCard,
    defaultAddress: defaultAddress,
  );
}
