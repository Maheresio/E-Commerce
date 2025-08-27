import 'package:equatable/equatable.dart';

import '../../../checkout/domain/entities/visa_card_entity.dart';
import '../../../auth/shared/domain/entity/user_entity.dart';

class ProfileModel extends Equatable {
  const ProfileModel({
    required this.userId,
    required this.ordersCount,
    required this.addressesCount,
    this.defaultCard,
    required this.profileItems,
    this.userEntity,
  });
  final String userId;
  final int ordersCount;
  final int addressesCount;
  final VisaCardEntity? defaultCard;
  final List<Map<String, String>> profileItems;
  final UserEntity? userEntity;

  ProfileModel copyWith({
    String? userId,
    int? ordersCount,
    int? addressesCount,
    VisaCardEntity? defaultCard,
    List<Map<String, String>>? profileItems,
    UserEntity? userEntity,
  }) => ProfileModel(
    userId: userId ?? this.userId,
    ordersCount: ordersCount ?? this.ordersCount,
    addressesCount: addressesCount ?? this.addressesCount,
    defaultCard: defaultCard ?? this.defaultCard,
    profileItems: profileItems ?? this.profileItems,
    userEntity: userEntity ?? this.userEntity,
  );

  @override
  List<Object?> get props => <Object?>[
    userId,
    ordersCount,
    addressesCount,
    defaultCard,
    profileItems,
    userEntity,
  ];
}
