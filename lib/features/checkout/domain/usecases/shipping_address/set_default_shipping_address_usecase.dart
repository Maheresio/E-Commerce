import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/shipping_address_repository.dart';

class SetDefaultShippingAddressUseCase {
  SetDefaultShippingAddressUseCase(this.repository);
  final ShippingAddressRepository repository;

  Future<Either<Failure, void>> execute(String addressId) =>
      repository.setDefault(addressId);
}
