import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../repositories/checkout_repository.dart';

class PresentPaymentSheetUsecase {
  PresentPaymentSheetUsecase(this.repository);
  final CheckoutRepository repository;

  Future<Either<Failure, void>> execute() => repository.presentPaymentSheet();
}
