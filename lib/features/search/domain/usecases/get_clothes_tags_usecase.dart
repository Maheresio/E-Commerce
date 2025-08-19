import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/search_repository.dart';

class GetClothesTagsUsecase {
  GetClothesTagsUsecase(this.repository);
  final SearchRepository repository;

  Future<Either<Failure, List<String>>> execute(String imageUrl) async =>
      repository.getTags(imageUrl);
}
