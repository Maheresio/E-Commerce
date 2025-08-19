import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/search_repository.dart';

class DeleteImageUsecase {
  DeleteImageUsecase(this.repository);
  final SearchRepository repository;

  Future<Either<Failure, void>> execute(String filePathInBucket) =>
      repository.deleteImage(filePathInBucket);
}
