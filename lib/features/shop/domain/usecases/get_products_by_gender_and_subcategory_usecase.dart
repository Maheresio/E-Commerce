import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../repositories/shop_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

class GetProductsByGenderAndSubCategoryUseCase {
  GetProductsByGenderAndSubCategoryUseCase(this.repository);
  final ShopRepository repository;

  Future<Either<Failure, List<ProductEntity>>> execute(
    String gender,
    String subCategory, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => repository.getProductsByGenderAndSubCategory(
    gender,
    subCategory,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
}
