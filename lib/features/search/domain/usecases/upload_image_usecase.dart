import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/search/domain/repositories/search_repository.dart';

class UploadImageUsecase {
  final SearchRepository repository;

  UploadImageUsecase(this.repository);

  Future<Either<Failure, String>> execute(Uint8List bytes) async =>
      await repository.uploadImage(bytes);
}
