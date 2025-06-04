import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/search/domain/repositories/search_repository.dart';

class GetClothesTagsUsecase {
  final SearchRepository repository;

  GetClothesTagsUsecase(this.repository);

  Future<Either<Failure, List<String>>> execute(String imageUrl) async =>
      await repository.getTags(imageUrl);
}
