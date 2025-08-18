import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<ProductModel> getProductById(String productId);
}

class HomeDataSourceImpl implements HomeDataSource {

  HomeDataSourceImpl(this.firestoreServices);
  final FirestoreServices firestoreServices;
  @override
  Stream<List<ProductModel>> newProducts() => firestoreServices.collectionsStream(
      path: FirestoreConstants.products,
      builder:
          (data, documentId, snapshot) =>
              ProductModel.fromMap(data!, documentId, snapshot),
      queryBuilder:
          (query) => query.orderBy('createdAt', descending: true).limit(10),
    );

  @override
  Stream<List<ProductModel>> saleProducts() =>
      firestoreServices.collectionsStream(
        path: FirestoreConstants.products,
        builder:
            (Map<String, dynamic>? data, String documentId, DocumentSnapshot<Object?> snapshot) =>
                ProductModel.fromMap(data!, documentId, snapshot),
        queryBuilder:
            (Query<Object?> query) => query.where('discountValue', isNotEqualTo: 0).limit(10),
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

  @override
  Future<ProductModel> getProductById(String productId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await firestoreServices.getDocument(
      path: FirestoreConstants.product(productId),
    );

    if (!doc.exists) {
      throw Exception('Product not found');
    }

    return ProductModel.fromMap(doc.data()!, doc.id, doc);
  }
}
