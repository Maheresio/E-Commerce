import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/order/get_my_orders_usecase.dart';
import '../../../domain/usecases/order/get_order_details_usecase.dart';
import '../../../domain/usecases/order/submit_order_usecase.dart';
import '../../../domain/usecases/order/watch_order_status_usecase.dart';
import '../../../domain/usecases/order/create_payment_intent_usecase.dart';
import '../../../domain/usecases/order/save_order_after_payment_usecase.dart';
import '../visa_card/visa_card_providers.dart';
import 'order_providers.dart';

final Provider<GetMyOrdersUseCase> getMyOrdersUseCaseProvider = Provider(
  (ref) => GetMyOrdersUseCase(ref.read(orderRepositoryProvider)),
);

final Provider<GetOrderDetailsUseCase> getOrderDetailsUseCaseProvider =
    Provider(
      (ref) => GetOrderDetailsUseCase(ref.read(orderRepositoryProvider)),
    );

final Provider<SubmitOrderUseCase> submitOrderUseCaseProvider = Provider(
  (ref) => SubmitOrderUseCase(
    orderRepo: ref.read(orderRepositoryProvider),
    cardRepo: ref.read(visaCardRepositoryProvider),
  ),
);

final Provider<WatchOrderStatusUseCase> watchOrderStatusUseCaseProvider =
    Provider(
      (ref) => WatchOrderStatusUseCase(ref.read(orderRepositoryProvider)),
    );

final Provider<CreatePaymentIntentUseCase> createPaymentIntentUseCaseProvider =
    Provider(
      (ref) => CreatePaymentIntentUseCase(
        orderRepo: ref.read(orderRepositoryProvider),
      ),
    );

final Provider<SaveOrderAfterPaymentUseCase>
saveOrderAfterPaymentUseCaseProvider = Provider(
  (ref) => SaveOrderAfterPaymentUseCase(
    orderRepo: ref.read(orderRepositoryProvider),
  ),
);
