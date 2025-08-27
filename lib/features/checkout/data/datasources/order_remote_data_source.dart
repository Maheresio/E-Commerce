import 'package:dio/dio.dart';

import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../../../core/network/dio_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/utils/payment_constants.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<void> submitOrder(OrderModel model);
  Future<String> createPaymentIntent({
    required String orderId,
    required String customerId,
    required double amount,
    String? paymentMethodId,
  });
  Future<List<OrderModel>> getMyOrders(String userId);
  Future<OrderModel> getOrderDetails(String orderId);
  Stream<OrderModel> watchOrderStatus(String orderId);

  // Transaction-based methods for duplication prevention
  Future<OrderModel?> checkOrderExists(String orderId);
  Future<String> getExistingPaymentIntent(String orderId);
  Future<String> submitOrderWithTransaction(
    OrderModel model, {
    required String customerId,
    required double amount,
    String? paymentMethodId,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  OrderRemoteDataSourceImpl({required this.firestore, required this.dio});
  final FirestoreServices firestore;
  final DioClient dio;

  @override
  Future<void> submitOrder(OrderModel model) async => firestore.setData(
    path: FirestoreConstants.order(model.id),
    data: model.toMap(),
  );

  @override
  Future<String> createPaymentIntent({
    required String orderId,
    required String customerId,
    required double amount,
    String? paymentMethodId,
  }) async {
    // Convert amount from dollars to cents for Stripe
    final amountInCents = (amount * 100).round();

    final Map<String, Object> requestData = <String, Object>{
      'orderId': orderId,
      'customerId': customerId,
      'amount': amountInCents,
      if (paymentMethodId != null) 'paymentMethodId': paymentMethodId,
    };

    final Response response = await dio.post(
      url: PaymentConstants.createPaymentIntentUrl,
      data: requestData,
    );

    final String clientSecret = response.data['clientSecret'] as String;

    return clientSecret;
  }

  @override
  Future<List<OrderModel>> getMyOrders(String userId) =>
      firestore.getCollection<OrderModel>(
        path: FirestoreConstants.orders,
        queryBuilder: (q) => q.where('userId', isEqualTo: userId),
        builder: (data, id, _) => OrderModel.fromMap(id, data!),
      );

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    final DocumentSnapshot<Map<String, dynamic>> snap = await firestore
        .getDocument(path: FirestoreConstants.order(orderId));
    final Map<String, dynamic>? data = snap.data();
    return OrderModel.fromMap(snap.id, data!);
  }

  @override
  Stream<OrderModel> watchOrderStatus(String orderId) =>
      firestore.documentsStream<OrderModel>(
        path: FirestoreConstants.order(orderId),
        builder: (data, id) => OrderModel.fromMap(id, data!),
      );

  @override
  Future<OrderModel?> checkOrderExists(String orderId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snap = await firestore
          .getDocument(path: FirestoreConstants.order(orderId));

      if (!snap.exists) {
        return null;
      }

      final Map<String, dynamic>? data = snap.data();
      return OrderModel.fromMap(snap.id, data!);
    } catch (e) {
      // Order doesn't exist
      return null;
    }
  }

  @override
  Future<String> getExistingPaymentIntent(String orderId) async {
    // In a real implementation, you would store the clientSecret in the order
    // For now, we'll create a new one if needed
    throw UnimplementedError(
      'Existing payment intent retrieval not implemented',
    );
  }

  @override
  Future<String> submitOrderWithTransaction(
    OrderModel model, {
    required String customerId,
    required double amount,
    String? paymentMethodId,
  }) async {
    // Use Firestore transaction to ensure atomic operation
    return FirebaseFirestore.instance.runTransaction<String>((
      Transaction transaction,
    ) async {
      // Check if order already exists
      final DocumentReference<Map<String, dynamic>> orderRef = FirebaseFirestore
          .instance
          .collection(FirestoreConstants.orders)
          .doc(model.id);

      final DocumentSnapshot<Map<String, dynamic>> orderSnapshot =
          await transaction.get(orderRef);

      if (orderSnapshot.exists) {
        // Order already exists, throw error to prevent duplication
        throw Exception('Order with ID ${model.id} already exists');
      }

      // Create the order atomically
      transaction.set(orderRef, model.toMap());

      // Create PaymentIntent via Cloud Function
      final String clientSecret = await createPaymentIntent(
        orderId: model.id,
        customerId: customerId,
        amount: amount,
        paymentMethodId: paymentMethodId,
      );

      return clientSecret;
    });
  }
}
