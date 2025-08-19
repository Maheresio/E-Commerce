import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../home/data/models/product_model.dart';
import '../repositories/search_repository.dart';

class SearchProductsByTagsUseCase {
  SearchProductsByTagsUseCase(this.repository);
  final SearchRepository repository;

  Future<Either<Failure, List<ProductModel>>> execute(
    List<String> tags, {
    DocumentSnapshot? lastDocument,
    int pageSize = 10,
  }) => repository.searchProductsByTags(
    tags,
    lastDocument: lastDocument,
    pageSize: pageSize,
  );
}
