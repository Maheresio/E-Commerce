import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../../home/data/models/product_model.dart';

abstract class FavoriteDataSource {
  Future<void> addFavorite(String userId, ProductModel product);
  Future<void> removeFavorite(String userId, String productId);
  Future<bool> isFavorite(String userId, String productId);
  Future<List<ProductModel>> getFavorites(String userId);
}

class FavoriteDataSourceImpl implements FavoriteDataSource {
  FavoriteDataSourceImpl(this.firestore);
  final FirestoreServices firestore;

  @override
  Future<void> addFavorite(String userId, ProductModel product) async {
    final String id = await firestore.getPath();
    await firestore.setData(
      path: FirestoreConstants.userFavorite(userId, product.id),
      data: product.toMap(id),
    );
  }

  @override
  Future<void> removeFavorite(String userId, String productId) async {
    await firestore.deleteData(
      path: FirestoreConstants.userFavorite(userId, productId),
    );
  }

  @override
  Future<bool> isFavorite(String userId, String productId) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await FirebaseFirestore.instance
            .doc(FirestoreConstants.userFavorite(userId, productId))
            .get();
    return doc.exists;
  }

  @override
  Future<List<ProductModel>> getFavorites(String userId) =>
      firestore.getCollection<ProductModel>(
        path: FirestoreConstants.userAllFavorites(userId),
        builder: (data, id, doc) => ProductModel.fromMap(data!, id, doc),
      );
}
