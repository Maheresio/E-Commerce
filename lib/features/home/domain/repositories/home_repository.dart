import '../entities/product_entity.dart';


abstract class HomeRepository {
  Stream<List<ProductEntity>> saleProducts();
  Stream<List<ProductEntity>> newProducts();
  Future<void> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  });
}
