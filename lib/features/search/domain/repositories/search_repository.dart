import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../home/data/models/product_model.dart';

abstract class SearchRepository {
  Future<Either<Failure, String>> uploadImage(
    Uint8List bytes, {
    String? fileName,
  });
  Future<Either<Failure, List<String>>> getTags(String imageUrl);
  Future<Either<Failure, List<ProductModel>>> searchProductsByTags(
    List<String> tags, {
    DocumentSnapshot? lastDocument,
    int pageSize,
  });
  Future<Either<Failure, void>> deleteImage(String filePathInBucket);
  Future<Either<Failure, void>> clearAllImages();
}
