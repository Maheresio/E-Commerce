import '../../../../core/services/current_user_service.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../checkout/domain/entities/visa_card_entity.dart';
import '../../../checkout/presentation/controller/order/order_notifier.dart';
import '../../../checkout/presentation/controller/shipping_address/shipping_address_providers.dart';
import 'profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/service_locator.dart';
import '../../../auth/shared/domain/repositories/auth_repository.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../checkout/domain/entities/shipping_address_entity.dart';
import '../../../checkout/presentation/controller/visa_card/visa_card_notifier.dart';
import '../../../auth/shared/domain/entity/user_entity.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => sl<AuthRepository>(),
);

class ProfileProvider extends AsyncNotifier<ProfileModel> {
  @override
  Future<ProfileModel> build() async {
    final String userId = await getUserId();

    final List<Object?> results = await Future.wait(<Future<Object?>>[
      getMyOrdersCount(userId),
      getMyAddressesCount(userId),
      getDefaultCard(userId),
      getCurrentUserEntity(),
    ]);

    final int myOrdersCount = results[0]! as int;
    final int myAddressesCount = results[1]! as int;
    final VisaCardEntity? defaultCard = results[2] as VisaCardEntity?;
    final UserEntity? userEntity = results[3] as UserEntity?;

    return ProfileModel(
      userId: userId,
      ordersCount: myOrdersCount,
      addressesCount: myAddressesCount,
      defaultCard: defaultCard,
      userEntity: userEntity,
      profileItems: _generateProfileItems(
        myOrdersCount,
        myAddressesCount,
        defaultCard,
      ),
    );
  }

  List<Map<String, String>> _generateProfileItems(
    int ordersCount,
    int addressesCount,
    VisaCardEntity? defaultCard,
  ) => [
    {'title': AppStrings.kMyOrders, 'subtitle': AppStrings.kAlreadyHaveOrders.replaceAll('%s', ordersCount.toString())},
    {'title': AppStrings.kMyAddresses, 'subtitle': AppStrings.kAddressesCount.replaceAll('%s', addressesCount.toString())},
    {
      'title': AppStrings.kPaymentMethods,
      'subtitle': AppStrings.kVisaCardFormat.replaceAll('%s', defaultCard?.last4.substring(2) ?? AppStrings.kNotAvailable),
    },
    {'title': AppStrings.kNotifications, 'subtitle': AppStrings.kNotificationsSettings},
    {'title': AppStrings.kSettings, 'subtitle': AppStrings.kSettingsPreferences},
    {'title': AppStrings.kLogout, 'subtitle': AppStrings.kSignOutAccount},
  ];

  Future<String> getUserId() async {
    final currentUserService = sl<CurrentUserService>();
    final String? userId = currentUserService.currentUserId;
    if (userId == null) throw Exception(AppStrings.kUserNotLoggedIn);
    return userId;
  }

  Future<int> getMyOrdersCount(String userId) async {
    await ref.read(orderNotifierProvider.notifier).refreshOrders();

    final AsyncValue<List<OrderEntity>> orders = ref.read(
      orderNotifierProvider,
    );

    final int orderCount = orders.when(
      data: (List<OrderEntity> orderList) => orderList.length,
      loading: () => 0,
      error: (Object error, StackTrace stack) {
        return 0;
      },
    );
    return orderCount;
  }

  Future<int> getMyAddressesCount(String userId) async {
    await ref.read(shippingAddressNotifierProvider.notifier).refresh();

    final AsyncValue<List<ShippingAddressEntity>> addresses = ref.read(
      shippingAddressNotifierProvider,
    );
    return addresses.when(
      data: (List<ShippingAddressEntity> addressList) => addressList.length,
      loading: () => 0,
      error: (Object error, StackTrace stack) => 0,
    );
  }

  Future<VisaCardEntity?> getDefaultCard(String userId) async {
    try {
      await ref.read(visaCardNotifierProvider.notifier).refresh();

      return ref.read(visaCardNotifierProvider.notifier).getDefaultCard();
    } catch (e) {
      debugPrint(AppStrings.kErrorGettingDefaultCard.replaceAll('%s', e.toString()));
      return null;
    }
  }

  Future<UserEntity?> getCurrentUserEntity() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.getCurrentUserData();
    return result.fold((failure) => null, (user) => user);
  }

  Future<void> logout() async {
    final AuthRepository authRepository = ref.read(authRepositoryProvider);
    await authRepository.logOut();
  }
}

final profileProvider = AsyncNotifierProvider<ProfileProvider, ProfileModel>(
  ProfileProvider.new,
);
