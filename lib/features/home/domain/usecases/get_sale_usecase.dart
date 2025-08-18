import '../entities/product_entity.dart';
import '../repositories/home_repository.dart';

class GetSaleUsecase {
  GetSaleUsecase(this.homeRepository);
  final HomeRepository homeRepository;

  Stream<List<ProductEntity>> execute() => homeRepository.saleProducts();
}
