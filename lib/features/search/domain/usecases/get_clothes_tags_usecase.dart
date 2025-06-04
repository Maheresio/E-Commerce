import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repositories/search_repository.dart';

class GetClothesTagsUsecase {
  final SearchRepository repository;

  GetClothesTagsUsecase(this.repository);

  Future<Either<Failure, List<String>>> execute(String imageUrl) async =>
      await repository.getTags(imageUrl);
}
