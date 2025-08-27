import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../repositories/shipping_address_repository.dart';

class DeleteShippingAddressUseCase {
  DeleteShippingAddressUseCase(this.repository);
  final ShippingAddressRepository repository;

  Future<Either<Failure, void>> execute(String addressId) =>
      repository.deleteAddress(addressId);
}
