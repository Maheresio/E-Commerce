import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/error/handle_repository_exceptions.dart';
import '../../domain/entities/delivery_method_entity.dart';
import '../../domain/repositories/delivery_method_repository.dart';
import '../datasources/delivery_method_remote_data_source.dart';

class DeliveryMethodRepositoryImpl implements DeliveryMethodRepository {
  DeliveryMethodRepositoryImpl(this.remoteDataSource);
  final DeliveryMethodRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<DeliveryMethodEntity>>> getDeliveryMethods() =>
      handleRepositoryExceptions(() async {
        final list = await remoteDataSource.getDeliveryMethods();
        return list.map((e) => e.toEntity()).toList();
      });
}
