import 'package:dartz/dartz.dart';

import '../../../../../core/error/failure.dart';
import '../../entities/shipping_address_entity.dart';
import '../../repositories/shipping_address_repository.dart';

class UpdateShippingAddressUseCase {
  UpdateShippingAddressUseCase(this.repository);
  final ShippingAddressRepository repository;

  Future<Either<Failure, void>> execute(ShippingAddressEntity address) =>
      repository.updateAddress(address);
}
