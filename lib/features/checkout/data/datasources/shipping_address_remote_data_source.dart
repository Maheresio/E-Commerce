import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../models/shipping_address_model.dart';

abstract class ShippingAddressRemoteDataSource {
  Future<void> addAddress(String userId, ShippingAddressModel address);
  Future<void> deleteAddress(String userId, String addressId);
  Future<void> updateAddress(
    String userId,
    ShippingAddressModel address,
  ); // ✅ NEW
  Future<void> setDefault(String userId, String addressId);
  Future<List<ShippingAddressModel>> getAddresses(String userId);
}

class ShippingAddressRemoteDataSourceImpl
    implements ShippingAddressRemoteDataSource {
  ShippingAddressRemoteDataSourceImpl(this.firestore);
  final FirestoreServices firestore;

  @override
  Future<void> addAddress(String userId, ShippingAddressModel address) async {
    await firestore.setData(
      path: FirestoreConstants.userAddress(userId, address.id),
      data: address.toMap(),
    );
  }

  @override
  Future<void> deleteAddress(String userId, String addressId) async {
    await firestore.deleteData(
      path: FirestoreConstants.userAddress(userId, addressId),
    );
  }

  @override
  Future<void> updateAddress(
    String userId,
    ShippingAddressModel address,
  ) async {
    await firestore.updateData(
      path: FirestoreConstants.userAddress(userId, address.id),
      data: address.toMap(),
    );
  }

  @override
  Future<List<ShippingAddressModel>> getAddresses(String userId) =>
      firestore.getCollection<ShippingAddressModel>(
        path: FirestoreConstants.userAllAddresses(userId),
        builder: (data, id, _) => ShippingAddressModel.fromMap(data!, id),
      );

  @override
  Future<void> setDefault(String userId, String addressId) async {
    final List<ShippingAddressModel> addresses = await getAddresses(userId);
    for (ShippingAddressModel addr in addresses) {
      final bool isDefault = addr.id == addressId;
      await firestore.updateData(
        path: FirestoreConstants.userAddress(userId, addr.id),
        data: <String, dynamic>{'isDefault': isDefault},
      );
    }
  }
}
