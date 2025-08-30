import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/order_entity.dart';
import '../../repositories/order_repository.dart';

class WatchOrderStatusUseCase {
  WatchOrderStatusUseCase(this.repo);
  final OrderRepository repo;

  Stream<Either<Failure, OrderEntity>> execute(String orderId) =>
      repo.watchOrderStatus(orderId);
}
