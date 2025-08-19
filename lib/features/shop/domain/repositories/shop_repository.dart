import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../home/domain/entities/product_entity.dart';

import '../../../../core/error/failure.dart';
import '../../presentation/controller/filter_models.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    DocumentSnapshot? lastDocument,
    int pageSize,
  });

  Future<Either<Failure, List<ProductEntity>>> getSaleProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  });

  Future<Either<Failure, List<ProductEntity>>> getNewestProducts({
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
  Future<Either<Failure, List<ProductEntity>>> getNewestProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
  Future<Either<Failure, List<ProductEntity>>> getProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
  Future<Either<Failure, List<ProductEntity>>>
  getProductsByGenderAndSubCategory(
    String gender,
    String subCategory, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
  Future<Either<Failure, List<ProductEntity>>> getFilteredProducts(
    FilterParams params, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
}
