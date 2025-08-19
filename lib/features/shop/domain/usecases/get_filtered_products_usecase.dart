import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../repositories/shop_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../presentation/controller/filter_models.dart';

class GetFilteredProductsUseCase {
  GetFilteredProductsUseCase(this.repository);
  final ShopRepository repository;

  Future<Either<Failure, List<ProductEntity>>> execute(
    FilterParams params, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => repository.getFilteredProducts(
    params,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
}
