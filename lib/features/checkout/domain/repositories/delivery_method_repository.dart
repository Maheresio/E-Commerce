import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/delivery_method_entity.dart';

abstract class DeliveryMethodRepository {
  Future<Either<Failure, List<DeliveryMethodEntity>>> getDeliveryMethods();
}
