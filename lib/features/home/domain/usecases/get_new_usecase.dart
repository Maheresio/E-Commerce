import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetNewUsecase {
  GetNewUsecase(this.homeRepository);
  final HomeRepository homeRepository;

  Stream<List<ProductEntity>> execute() => homeRepository.newProducts();
}
