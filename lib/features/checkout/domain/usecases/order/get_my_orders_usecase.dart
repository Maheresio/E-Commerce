import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';

import '../../entities/order_entity.dart';
import '../../repositories/order_repository.dart';

class GetMyOrdersUseCase {
  GetMyOrdersUseCase(this.repo);
  final OrderRepository repo;

  Future<Either<Failure, List<OrderEntity>>> execute(String userId) =>
      repo.getMyOrders(userId);
}
