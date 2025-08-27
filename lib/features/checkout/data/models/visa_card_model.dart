import '../../domain/entities/visa_card_entity.dart';

class VisaCardModel extends VisaCardEntity {
  factory VisaCardModel.fromEntity(VisaCardEntity entity) {
    return VisaCardModel(
      id: entity.id,
      last4: entity.last4,
      expMonth: entity.expMonth,
      expYear: entity.expYear,
      holderName: entity.holderName,
      isDefault: entity.isDefault,
    );
  }
  const VisaCardModel({
    required super.id,
    required super.last4,
    required super.expMonth,
    required super.expYear,
    required super.holderName,
    required super.isDefault,
  });

  factory VisaCardModel.fromMap(Map<String, dynamic> json) => VisaCardModel(
    id: json['id'],
    last4: json['last4'],
    expMonth: json['expMonth'].toString(),
    expYear: json['expYear'].toString(),
    holderName: json['name'] ?? '',
    isDefault: json['isDefault'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'last4': last4,
    'expMonth': expMonth,
    'expYear': expYear,
    'name': holderName,
    'isDefault': isDefault,
  };

  VisaCardEntity toEntity() => VisaCardEntity(
    id: id,
    last4: last4,
    expMonth: expMonth,
    expYear: expYear,
    holderName: holderName,
    isDefault: isDefault,
  );

  VisaCardModel copyWith({
    String? id,
    String? last4,
    String? expMonth,
    String? expYear,
    String? holderName,
    bool? isDefault,
  }) => VisaCardModel(
    id: id ?? this.id,
    last4: last4 ?? this.last4,
    expMonth: expMonth ?? this.expMonth,
    expYear: expYear ?? this.expYear,
    holderName: holderName ?? this.holderName,
    isDefault: isDefault ?? this.isDefault,
  );
}
