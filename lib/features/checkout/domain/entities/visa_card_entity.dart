import 'package:equatable/equatable.dart';

class VisaCardEntity extends Equatable {
  const VisaCardEntity({
    required this.id,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.holderName,
    this.isDefault = false,
  });
  final String id;
  final String last4;
  final String expMonth;
  final String expYear;
  final String holderName;
  final bool isDefault;

  @override
  List<Object?> get props => <Object?>[
    id,
    last4,
    expMonth,
    expYear,
    holderName,
    isDefault,
  ];
}
