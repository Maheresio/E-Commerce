import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../entities/delivery_method_entity.dart';
import '../../repositories/delivery_method_repository.dart';

class GetDeliveryMethodsUseCase {
  GetDeliveryMethodsUseCase(this.repository);
  final DeliveryMethodRepository repository;

  Future<Either<Failure, List<DeliveryMethodEntity>>> execute() =>
      repository.getDeliveryMethods();
}
