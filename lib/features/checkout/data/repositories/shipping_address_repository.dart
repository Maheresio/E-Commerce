import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/handle_repository_exceptions.dart';
import '../../../../../core/services/current_user_service.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/repositories/shipping_address_repository.dart';
import '../datasources/shipping_address_remote_data_source.dart';
import '../models/shipping_address_model.dart';

class ShippingAddressRepositoryImpl implements ShippingAddressRepository {
  ShippingAddressRepositoryImpl(this.remoteDataSource, this.currentUserService);
  final ShippingAddressRemoteDataSource remoteDataSource;
  final CurrentUserService currentUserService;

  @override
  Future<Either<Failure, void>> addAddress(ShippingAddressEntity address) =>
      handleRepositoryExceptions(() async {
        final uid = currentUserService.currentUserId;
        if (uid == null) throw Exception('User not logged in');
        await remoteDataSource.addAddress(
          uid,
          ShippingAddressModel.fromEntity(address),
        );
      });

  @override
  Future<Either<Failure, void>> deleteAddress(String addressId) =>
      handleRepositoryExceptions(() async {
        final uid = currentUserService.currentUserId;
        if (uid == null) throw Exception('User not logged in');
        await remoteDataSource.deleteAddress(uid, addressId);
      });

  @override
  Future<Either<Failure, List<ShippingAddressEntity>>> getAddresses() =>
      handleRepositoryExceptions(() async {
        final uid = currentUserService.currentUserId;
        if (uid == null) throw Exception('User not logged in');
        final addresses = await remoteDataSource.getAddresses(uid);
        return addresses.map((e) => e.toEntity()).toList();
      });

  @override
  Future<Either<Failure, void>> setDefault(String addressId) =>
      handleRepositoryExceptions(() async {
        final uid = currentUserService.currentUserId;
        if (uid == null) throw Exception('User not logged in');
        await remoteDataSource.setDefault(uid, addressId);
      });

  @override
  Future<Either<Failure, void>> updateAddress(ShippingAddressEntity address) =>
      handleRepositoryExceptions(() async {
        final uid = currentUserService.currentUserId;
        if (uid == null) throw Exception('User not logged in');
        await remoteDataSource.updateAddress(
          uid,
          ShippingAddressModel.fromEntity(address),
        );
      });
}
