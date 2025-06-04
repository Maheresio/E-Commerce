import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class SearchRepository {
  Future<Either<Failure, String>> uploadImage(Uint8List bytes);
  Future<Either<Failure, List<String>>> getTags(String imageUrl);

  // Future<List<Product>> searchProducts(List<String> tags);
}
