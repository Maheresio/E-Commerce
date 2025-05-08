import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';


class GetSaleUsecase {
  final HomeRepository homeRepository;

  GetSaleUsecase(this.homeRepository);

  /// Fetches the list of products currently on sale.
  /// Returns a stream that emits updates in real-time.

  Stream<List<ProductEntity>> execute() {
    return homeRepository.saleProducts();
  }
}
