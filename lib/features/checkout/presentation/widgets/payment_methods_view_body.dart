import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/visa_card_entity.dart';
import '../controller/visa_card/visa_card_notifier.dart';
import 'visa_card_item.dart';

class PaymentMethodsViewBody extends ConsumerWidget {
  const PaymentMethodsViewBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<VisaCardEntity>> state = ref.watch(
      visaCardNotifierProvider,
    );
    return state.when(
      data: (List<VisaCardEntity> cards) {
        if (cards.isEmpty) {
          return Center(
            child: Text(
              AppStrings.kNoPaymentMethodsAdded,
              style: AppStyles.font16PrimarySemiBold(context),
            ),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.kYourPaymentCards,
                style: AppStyles.font16BlackSemiBold(context),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, int index) {
                    final VisaCardEntity card = cards[index];
                    return Dismissible(
                      key: Key(card.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              AppStrings.kRemoveCard,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        final ThemeData theme = Theme.of(context);

                        final bool? confirmed = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (BuildContext context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                titlePadding: const EdgeInsets.fromLTRB(
                                  24,
                                  24,
                                  24,
                                  8,
                                ),
                                contentPadding: const EdgeInsets.fromLTRB(
                                  24,
                                  8,
                                  24,
                                  0,
                                ),
                                actionsPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                title: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.credit_card_off,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      AppStrings.kRemoveCard,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                content: Text(
                                  AppStrings.kRemoveCardConfirmation
                                      .replaceFirst('%s', card.last4),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                                actions: <Widget>[
                                  OutlinedButton(
                                    onPressed:
                                        () =>context.pop(false),
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      side: BorderSide(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    child: Text(
                                      AppStrings.kCancel,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () =>context.pop(true),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.error,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      AppStrings.kRemoveCard,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (confirmed == true) {
                          final String? userId =
                              FirebaseAuth.instance.currentUser?.uid;
                          if (userId != null) {
                            await ref
                                .read(visaCardNotifierProvider.notifier)
                                .deleteCard(
                                  userId: userId,
                                  paymentMethodId: card.id,
                                );

                            if (context.mounted) {
                              openStyledSnackBar(
                                context,
                                text: AppStrings.kCardRemoved.replaceFirst(
                                  '%s',
                                  card.last4,
                                ),
                                type: SnackBarType.success,
                              );
                            }
                          }
                        }

                        return confirmed ?? false;
                      },
                      child: VisaCardItem(card),
                    );
                  },
                  separatorBuilder: (_, int index) => SizedBox(height: 30.h),
                  itemCount: cards.length,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (Object error, StackTrace stackTrace) => Center(
            child: Text(
              AppStrings.kErrorPrefix.replaceFirst('%s', error.toString()),
            ),
          ),
    );
  }
}
