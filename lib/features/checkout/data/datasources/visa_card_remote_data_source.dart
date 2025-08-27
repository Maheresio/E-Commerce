import 'package:dio/dio.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/firestore_sevice.dart';
import '../../presentation/utils/payment_constants.dart';
import '../../../../core/services/current_user_service.dart';
import '../models/visa_card_model.dart';

abstract class VisaCardRemoteDataSource {
  Future<List<VisaCardModel>> getSavedCards(String userId);
  Future<String> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardModel card,
  });
  Future<void> deleteCard({
    required String userId,
    required String paymentMethodId,
  });
  Future<void> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
  });

  Future<String> getOrCreateCustomer();
  Future<String> createEphemeralKey(String customerId);
}

class VisaCardRemoteDataSourceImpl implements VisaCardRemoteDataSource {
  VisaCardRemoteDataSourceImpl({
    required this.dio,
    required this.firestore,
    required this.currentUserService,
  });
  final DioClient dio;
  final FirestoreServices firestore;
  final CurrentUserService currentUserService;

  @override
  Future<List<VisaCardModel>> getSavedCards(String userId) async =>
      firestore.getCollection<VisaCardModel>(
        path: FirestoreConstants.userVisaCards(userId),
        builder: (data, id, _) => VisaCardModel.fromMap(data!).copyWith(id: id),
      );

  @override
  Future<String> addCard({
    required String customerId,
    required String cardToken,
    required VisaCardModel card,
  }) async {
    try {
      final Response response = await dio.post(
        url: PaymentConstants.createSetupIntentUrl,
        data: <String, dynamic>{
          'customerId': customerId,
          'cardToken': cardToken,
        },
      );

      final VisaCardModel newCard = card.copyWith(
        id: response.data['paymentMethodId'],
      );

      final String? userId = currentUserService.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await firestore.setData(
        path: FirestoreConstants.userVisaCard(userId, newCard.id),
        data: newCard.toMap(),
      );

      return newCard.id;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCard({
    required String userId,
    required String paymentMethodId,
  }) async {
    // 1. Detach from Stripe
    await dio.post(
      url: PaymentConstants.detachCardUrl,
      data: <String, dynamic>{'paymentMethodId': paymentMethodId},
    );

    // 2. Remove from Firestore
    await firestore.deleteData(
      path: FirestoreConstants.userVisaCard(userId, paymentMethodId),
    );
  }

  @override
  Future<void> setDefaultCard({
    required String customerId,
    required String paymentMethodId,
  }) async {
    // 1. Set default on Stripe
    await dio.post(
      url: PaymentConstants.setDefaultCardUrl,
      data: <String, dynamic>{
        'customerId': customerId,
        'paymentMethodId': paymentMethodId,
      },
    );

    final String? userId = currentUserService.currentUserId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // 2. Update all cards in Firestore

    final List<VisaCardModel> cards = await getSavedCards(userId);
    for (final VisaCardModel card in cards) {
      await firestore.updateData(
        path: FirestoreConstants.userVisaCard(userId, card.id),
        data: <String, dynamic>{'isDefault': card.id == paymentMethodId},
      );
    }
  }

  @override
  Future<String> getOrCreateCustomer() async {
    final String? userId = currentUserService.currentUserId;
    final String? email = currentUserService.currentUserEmail;
    final String? name = currentUserService.currentUserDisplayName;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final Response response = await dio.post(
      url: PaymentConstants.getOrCreateCustomerUrl,

      data: <String, dynamic>{
        'firebaseUID': userId,
        'email': email ?? '',
        'name': name ?? '',
      },
    );

    return response.data['customerId'];
  }

  @override
  Future<String> createEphemeralKey(String customerId) async {
    final Response response = await dio.post(
      url: PaymentConstants.createEphemeralKeyUrl,
      data: <String, dynamic>{'customer_id': customerId},
    );

    return response.data['ephemeralKeySecret'] as String;
  }
}
