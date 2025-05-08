import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';

class UpdateProductUsecase {
  HomeRepository homeRepository;
  UpdateProductUsecase(this.homeRepository);

  Future<void> execute({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return homeRepository.updateProduct(id: id, data: data);
  }
}
