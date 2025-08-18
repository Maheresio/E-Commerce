import '../repositories/home_repository.dart';

class UpdateProductUsecase {
  UpdateProductUsecase(this.homeRepository);
  HomeRepository homeRepository;

  Future<void> execute({
    required String id,
    required Map<String, dynamic> data,
  }) => homeRepository.updateProduct(id: id, data: data);
}
