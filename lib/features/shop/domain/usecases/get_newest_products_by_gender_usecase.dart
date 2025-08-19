import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../repositories/shop_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../home/domain/entities/product_entity.dart';

class GetNewestProductsByGenderUseCase {
  GetNewestProductsByGenderUseCase(this.repository);
  final ShopRepository repository;

  Future<Either<Failure, List<ProductEntity>>> execute(
    String gender, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => repository.getNewestProductsByGender(
    gender,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
}
