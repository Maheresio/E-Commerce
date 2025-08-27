import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/error/failure.dart';
import '../../../domain/entities/delivery_method_entity.dart';
import 'delivery_method_usecase_providers.dart';

class DeliveryMethodActions {
  DeliveryMethodActions(this.ref);
  final Ref ref;

  Future<AsyncValue<List<DeliveryMethodEntity>>> loadDeliveryMethods() async {
    final Either<Failure, List<DeliveryMethodEntity>> result =
        await ref.read(getDeliveryMethodsUseCaseProvider).execute();

    return result.fold(
      (Failure failure) => AsyncError(failure.message, StackTrace.current),
      AsyncData.new,
    );
  }
}
