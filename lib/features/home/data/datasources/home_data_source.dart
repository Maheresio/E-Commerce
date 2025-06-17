import '../../../../core/services/firestore_sevice.dart';
import '../../../../core/constants/firestore_constants.dart';

import '../models/product_model.dart';

abstract class HomeDataSource {
  Stream<List<ProductModel>> saleProducts();
  Stream<List<ProductModel>> newProducts();
  Future<void> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  });
}

class HomeDataSourceImpl implements HomeDataSource {
  final FirestoreServices firestoreServices;

  HomeDataSourceImpl(this.firestoreServices);
  @override
  Stream<List<ProductModel>> newProducts() {
    return firestoreServices.collectionsStream(
      path: FirestoreConstants.products,
      builder: (data, documentId) => ProductModel.fromMap(data!, documentId),
      queryBuilder:
          (query) => query.orderBy('createdAt', descending: true).limit(10),
    );
  }

  @override
  Stream<List<ProductModel>> saleProducts() =>
      firestoreServices.collectionsStream(
        path: FirestoreConstants.products,
        builder: (data, documentId) => ProductModel.fromMap(data!, documentId),
        queryBuilder:
            (query) => query.where('discountValue', isNotEqualTo: 0).limit(10),
      );

  @override
  Future<void> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    await firestoreServices.updateData(
      path: FirestoreConstants.product(id),
      data: data,
    );
  }
}
