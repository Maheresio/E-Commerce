import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/domain/repositories/home_repository.dart';


class GetNewUsecase {
  final HomeRepository homeRepository;
  GetNewUsecase(this.homeRepository);

  /// Fetches the list of new products.
  /// Returns a stream that emits updates in real-time.

  Stream<List<ProductEntity>> execute() {
    return homeRepository.newProducts();
  }
}
