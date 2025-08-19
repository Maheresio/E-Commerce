import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/search_repository.dart';

class ClearAllImagesUsecase {
  ClearAllImagesUsecase(this.repository);
  final SearchRepository repository;

  Future<Either<Failure, void>> execute() => repository.clearAllImages();
}
