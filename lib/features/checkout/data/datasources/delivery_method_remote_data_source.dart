import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../models/delivery_method_model.dart';

abstract class DeliveryMethodRemoteDataSource {
  Future<List<DeliveryMethodModel>> getDeliveryMethods();
}

class DeliveryMethodRemoteDataSourceImpl
    implements DeliveryMethodRemoteDataSource {
  DeliveryMethodRemoteDataSourceImpl(this.firestore);
  final FirestoreServices firestore;

  @override
  Future<List<DeliveryMethodModel>> getDeliveryMethods() =>
      firestore.getCollection<DeliveryMethodModel>(
        path: FirestoreConstants.deliveryMethods,
        builder: (data, id, _) {
          return DeliveryMethodModel.fromMap(data!, id);
        },
      );
}
