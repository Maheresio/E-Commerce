import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/delivery_method/get_delivery_methods_usecase.dart';
import 'delivery_method_providers.dart';

final Provider<GetDeliveryMethodsUseCase> getDeliveryMethodsUseCaseProvider =
    Provider<GetDeliveryMethodsUseCase>(
      (ref) =>
          GetDeliveryMethodsUseCase(ref.read(deliveryMethodRepositoryProvider)),
    );
