import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../repositories/shop_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

class GetAllProductsUseCase {
  GetAllProductsUseCase(this.repository);
  final ShopRepository repository;

  Future<Either<Failure, List<ProductEntity>>> execute({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) =>
      repository.getAllProducts(lastDocument: lastDocument, pageSize: pageSize);
}
