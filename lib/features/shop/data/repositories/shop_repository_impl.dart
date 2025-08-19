import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/handle_repository_exceptions.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../datasources/shop_data_source.dart';
import '../../domain/repositories/shop_repository.dart';

import '../../presentation/controller/filter_models.dart';

class ShopRepositoryImpl implements ShopRepository {
  ShopRepositoryImpl(this.shopDataSource);
  final ShopDataSource shopDataSource;

  @override
  Future<Either<Failure, List<ProductEntity>>> getFilteredProducts(
    FilterParams params, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => await handleRepositoryExceptions(
    () async => await shopDataSource.getFilteredProducts(
      params,
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getAllProducts(
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getSaleProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getSaleProducts(
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getNewestProducts({
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getNewestProducts(
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getNewestProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getNewestProductsByGender(
      gender,
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByGender(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getProductsByGender(
      gender,
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );

  @override
  Future<Either<Failure, List<ProductEntity>>>
  getProductsByGenderAndSubCategory(
    String gender,
    String subCategory, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) async => handleRepositoryExceptions(
    () => shopDataSource.getProductsByGenderAndSubCategory(
      gender,
      subCategory,
      lastDocument: lastDocument,
      pageSize: pageSize,
    ),
  );
}
