import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/search_repository.dart';

class UploadImageUsecase {
  UploadImageUsecase(this.repository);
  final SearchRepository repository;

  Future<Either<Failure, String>> execute(
    Uint8List bytes, {
    String? fileName,
  }) async => repository.uploadImage(bytes, fileName: fileName);
}
