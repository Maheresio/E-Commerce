import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../models/cart_item_model.dart';

abstract class CartDataSource {
  Future<List<CartItemModel>> getCartItems(String userId);
  Future<void> addOrUpdateItem(String userId, CartItemModel item);
  Future<void> removeItem(String userId, String itemId);
  Future<void> clearCart(String userId);
}

class CartDataSourceImpl implements CartDataSource {
  CartDataSourceImpl(this.firestore);
  final FirestoreServices firestore;

  @override
  Future<List<CartItemModel>> getCartItems(String userId) async =>
      firestore.getCollection(
        path: FirestoreConstants.userCart(userId),
        builder: (data, id, doc) {
          return CartItemModel.fromMap(data!, id);
        },
      );

  @override
  Future<void> addOrUpdateItem(String userId, CartItemModel item) async {
    final String path = FirestoreConstants.userCartItem(userId, item.id);
    final Map<String, dynamic> data = item.toMap();

    await firestore.setData(path: path, data: data);
  }

  @override
  Future<void> removeItem(String userId, String itemId) async {
    final String path = FirestoreConstants.userCartItem(userId, itemId);
    await firestore.deleteData(path: path);
  }

  @override
  Future<void> clearCart(String userId) async {
    final String path = FirestoreConstants.userCart(userId);

    await firestore.deleteCollection(path: path);
  }
}
