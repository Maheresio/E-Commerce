import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/shipping_address_entity.dart';

abstract class ShippingAddressRepository {
  Future<Either<Failure, List<ShippingAddressEntity>>> getAddresses();
  Future<Either<Failure, void>> addAddress(ShippingAddressEntity address);
  Future<Either<Failure, void>> deleteAddress(String addressId);
  Future<Either<Failure, void>> updateAddress(ShippingAddressEntity address);
  Future<Either<Failure, void>> setDefault(String addressId);
}
