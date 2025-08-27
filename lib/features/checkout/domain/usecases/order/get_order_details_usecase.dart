import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/order_entity.dart';
import '../../repositories/order_repository.dart';

class GetOrderDetailsUseCase {
  GetOrderDetailsUseCase(this.repo);
  final OrderRepository repo;

  Future<Either<Failure, OrderEntity>> execute(String orderId) =>
      repo.getOrderDetails(orderId);
}
