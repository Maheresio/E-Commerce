import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import '../../../../core/widgets/styled_loading.dart';
import '../../../../core/widgets/summary_price.dart';
import '../../../cart/presentation/controller/cart_provider.dart';
import '../../data/models/visa_card_model.dart';
import '../../domain/entities/delivery_method_entity.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/entities/visa_card_entity.dart';
import '../controller/checkout/checkout_notifier.dart';
import '../controller/delivery_method/delivery_method_providers.dart';
import '../controller/shipping_address/shipping_address_providers.dart';
import '../controller/submission_protection_provider.dart';
import '../controller/visa_card/visa_card_notifier.dart';
import 'delivery_methods_shimmer.dart';
import 'payment_methods_shimmer.dart';
import 'shipping_address_card.dart';
import 'shipping_address_card_shimmer.dart';
import 'summary_shimmer.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody(this.cartTotal, {super.key});

  final double cartTotal;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24),
      child: Column(
        spacing: 50,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShippingAddressSection(),
          const PaymentSection(),
          const DeliveryMethodSection(),
          SummarySection(cartTotal),
          const SubmitSection(),
          SizedBox(height: 12.h),
        ],
      ),
    ),
  );
}

class SubmitSection extends ConsumerWidget {
  const SubmitSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = context.color.primary;
    final AsyncValue<String> checkoutState = ref.watch(
      checkoutNotifierProvider,
    );
    final bool isSubmissionProtected = ref.watch(submissionProtectionProvider);

    // Show loading if either checkout is loading or submission is protected
    final bool isLoading = checkoutState.isLoading || isSubmissionProtected;

    return Column(
      children: <Widget>[
        // Show processing message when submission is protected
        if (isSubmissionProtected)
          Container(
            padding: EdgeInsets.all(12.w),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: const StyledLoading(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    AppStrings.kProcessingYourOrder,
                    style: AppStyles.font14BlackMedium(
                      context,
                    ).copyWith(color: primary),
                  ),
                ),
              ],
            ),
          ),

        // Submit button
        if (isLoading)
          const StyledLoading(size: 30)
        else
          CircularElevatedButton(
            text: AppStrings.kSubmitOrder,
            onPressed:
                isSubmissionProtected
                    ? null // Disable button if submission is in progress
                    : () async {
                      await _submitOrderWithProtection(context, ref);
                    },
          ),
      ],
    );
  }

  Future<void> _submitOrderWithProtection(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      // Use submission protection to prevent double-tap
      await ref.read(submissionProtectionProvider.notifier).protectSubmission(
        () async {
          // Validate required data before submission
          await _validateCheckoutData(ref);

          // Get user ID and cart total
          final String userId = FirebaseAuth.instance.currentUser!.uid;
          final AsyncValue<double> cartTotalState = ref.read(
            cartTotalProvider(userId),
          );
          final double cartTotal = cartTotalState.valueOrNull ?? 0.0;

          // Generate unique idempotency key for this checkout attempt
          final String idempotencyKey =
              'checkout_${DateTime.now().millisecondsSinceEpoch}_${userId.hashCode}';

          // Create checkout data with idempotency protection
          final CheckoutData checkoutData = CheckoutData(
            userId: userId,
            cartTotal: cartTotal,
            idempotencyKey: idempotencyKey,
          );

          // Process complete checkout through notifier (includes payment sheet)
          await ref
              .read(checkoutNotifierProvider.notifier)
              .processCompleteCheckout(checkoutData);

          // Success - navigate to success page
          if (context.mounted) {
            openStyledSnackBar(
              context,
              text: AppStrings.kOrderSubmittedSuccessfully,
              type: SnackBarType.success,
            );
            context.go(AppRoutes.success);
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        final String errorMessage = e is Failure ? e.message : e.toString();
        openStyledSnackBar(
          context,
          text: errorMessage,
          type: SnackBarType.error,
        );
      }
    }
  }

  /// Validate all required checkout data before submission
  Future<void> _validateCheckoutData(WidgetRef ref) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw const Failure(AppStrings.kPleaseLogInToContinue);
    }

    // Check shipping address
    final List<ShippingAddressEntity>? addresses =
        ref.read(shippingAddressNotifierProvider).valueOrNull;
    if (addresses == null || addresses.isEmpty) {
      throw const Failure(AppStrings.kPleaseAddShippingAddress);
    }

    // Check payment method

    final List<VisaCardEntity>? cards =
        ref.read(visaCardNotifierProvider).valueOrNull;
    if (cards == null || cards.isEmpty) {
      throw const Failure(AppStrings.kPleaseAddPaymentMethod);
    }

    // Check delivery method
    final DeliveryMethodEntity? deliveryMethod = ref.read(
      selectedDeliveryMethodProvider,
    );
    if (deliveryMethod == null) {
      throw const Failure(AppStrings.kPleaseSelectDeliveryMethod);
    }

    // Check cart
    final double? cartTotal = ref.read(cartTotalProvider(userId)).valueOrNull;
    if (cartTotal == null || cartTotal <= 0) {
      throw const Failure(AppStrings.kYourCartIsEmpty);
    }
  }
}

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 20,
    children: [
      Text(
        AppStrings.kShippingAddress,
        style: AppStyles.font16BlackSemiBold(context),
      ),
      Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(shippingAddressNotifierProvider);

          return state.when(
            data: (addresses) {
              if (addresses.isEmpty) {
                return NoShippingAddressWidget(
                  onAddAddress: () {
                    context.push(AppRoutes.addShippingAddress);
                  },
                );
              }

              final defaultAddress = addresses.firstWhere(
                (addr) => addr.isDefault,
                orElse: () => addresses.first,
              );

              return ShippingAddressCard(
                address: defaultAddress,
                isEditable: false,
              );
            },

            loading: () => const ShippingAddressCardShimmer(),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    AppStrings.kErrorPrefix.replaceFirst(
                      '%s',
                      error.toString(),
                    ),
                  ),
                ),
          );
        },
      ),
    ],
  );
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return Column(
      spacing: 20,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.kPayment,
              style: AppStyles.font16BlackSemiBold(context),
            ),
            Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final cards =
                        ref.watch(visaCardNotifierProvider).valueOrNull ?? [];

                    if (cards.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return InkWell(
                      onTap: () async {
                        final confirmed = await _showRemoveAllConfirmationSheet(
                          context,
                        );
                        if (confirmed == true) {
                          try {
                            final userId =
                                FirebaseAuth.instance.currentUser?.uid;
                            if (userId != null) {
                              await ref
                                  .read(visaCardNotifierProvider.notifier)
                                  .deleteAllCards(userId);

                              if (context.mounted) {
                                openStyledSnackBar(
                                  context,
                                  text: AppStrings.kAllCardsRemovedSuccessfully,
                                  type: SnackBarType.success,
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              openStyledSnackBar(
                                context,
                                text: AppStrings.kFailedToRemoveCards
                                    .replaceFirst('%s', e.toString()),
                                type: SnackBarType.error,
                              );
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 12.w),
                        child: Text(
                          AppStrings.kRemoveAll,
                          style: AppStyles.font14PrimaryMedium(
                            context,
                          ).copyWith(color: themeColors.primary),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 24.w),
                  child: InkWell(
                    onTap: () {
                      context.push(AppRoutes.paymentMethods);
                    },
                    child: Text(
                      AppStrings.kChange,
                      style: AppStyles.font14PrimaryMedium(context),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(visaCardNotifierProvider);
            return state.when(
              data: (cards) {
                if (cards.isEmpty) {
                  return NoPaymentMethodsWidget(themeColors: themeColors);
                }

                final card = cards.firstWhere(
                  (c) => c.isDefault,
                  orElse: () => cards.last as VisaCardModel,
                );
                return Row(
                  spacing: 17.w,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: themeColors.onSecondary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 7.h,
                        ),
                        child: SvgPicture.asset(AppImages.mastercard),
                      ),
                    ),

                    Text(
                      AppStrings.kCardNumberMask.replaceFirst('%s', card.last4),
                      style: AppStyles.font14BlackMedium(context),
                    ),
                  ],
                );
              },
              loading: () => const PaymentMethodsShimmer(),
              error: (error, stackTrace) {
                return Center(
                  child: Text(
                    AppStrings.kErrorPrefix.replaceFirst(
                      '%s',
                      error.toString(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<bool?> _showRemoveAllConfirmationSheet(BuildContext context) async {
    final themeColors = context.color;

    return await Navigator.of(context).push<bool>(
      ModalSheetRoute(
        builder:
            (context) => Sheet(
              initialOffset: const SheetOffset(0.9),
              physics: const BouncingSheetPhysics(),
              snapGrid: const MultiSnapGrid(
                snaps: [SheetOffset(0.6), SheetOffset(0.9), SheetOffset(1.0)],
              ),
              child: SafeArea(
                top: false,
                child: Material(
                  color: themeColors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight * 0.96,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            16,
                            12,
                            16,
                            MediaQuery.viewInsetsOf(context).bottom + 24,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Handle bar
                              Container(
                                width: 36,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: themeColors.secondary.withValues(
                                    alpha: 0.25,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),

                              // Title
                              Text(
                                AppStrings.kRemoveAllCards,
                                style: AppStyles.font18BlackSemiBold(context),
                              ),
                              const SizedBox(height: 16),

                              // Content
                              Text(
                                AppStrings.kRemoveAllCardsConfirmation,
                                style: AppStyles.font14BlackMedium(context),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => context.pop(false),
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: themeColors.secondary
                                                  .withValues(alpha: 0.5),
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppStrings.kCancel,
                                              style:
                                                  AppStyles.font14BlackMedium(
                                                    context,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () => context.pop(true),
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            color: themeColors.primary
                                                .withValues(alpha: 0.1),
                                            border: Border.all(
                                              color: themeColors.primary,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppStrings.kRemoveAll,
                                              style:
                                                  AppStyles.font14BlackMedium(
                                                    context,
                                                  ).copyWith(
                                                    color: themeColors.primary,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class NoPaymentMethodsWidget extends StatelessWidget {
  const NoPaymentMethodsWidget({super.key, required this.themeColors});

  final ColorScheme themeColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: themeColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            color: themeColors.primary.withValues(alpha: 0.7),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            AppStrings.kNoPaymentMethodsAdded,
            style: AppStyles.font14BlackMedium(
              context,
            ).copyWith(color: themeColors.primary.withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}

class DeliveryMethodSection extends StatelessWidget {
  const DeliveryMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(
          AppStrings.kDeliveryMethod,
          style: AppStyles.font16BlackSemiBold(context),
        ),
        SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(deliveryMethodNotifierProvider);
              return state.when(
                data: (deliveryMethods) {
                  if (deliveryMethods.isEmpty) {
                    return const Center(
                      child: Text(AppStrings.kNoItemsInDelivery),
                    );
                  }

                  return DeliveryMethodsListView(
                    themeColors: themeColors,
                    deliveryMethods: deliveryMethods,
                  );
                },
                loading: () => const DeliveryMethodsShimmer(),
                error: (error, stackTrace) {
                  return Center(
                    child: Text(
                      AppStrings.kErrorPrefix.replaceFirst(
                        '%s',
                        error.toString(),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class DeliveryMethodsListView extends StatelessWidget {
  const DeliveryMethodsListView({
    super.key,
    required this.themeColors,
    required this.deliveryMethods,
  });

  final ColorScheme themeColors;
  final List<DeliveryMethodEntity> deliveryMethods;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final selectedDeliveryMethod = ref.watch(
          selectedDeliveryMethodProvider,
        );

        return SizedBox(
          height: 105.h,
          child: Row(
            spacing: 12.w,
            children:
                deliveryMethods.map((element) {
                  final isSelected = selectedDeliveryMethod?.id == element.id;

                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedDeliveryMethodProvider.notifier).state =
                          element;
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 110.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isSelected ? 0.15 : 0.1,
                            ),
                            blurRadius: isSelected ? 12 : 8,
                            spreadRadius: isSelected ? 2 : 1,
                            offset: Offset(0, isSelected ? 6 : 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors:
                              isSelected
                                  ? [
                                    themeColors.primary.withValues(alpha: 0.2),
                                    themeColors.primary.withValues(alpha: 0.1),
                                  ]
                                  : [Colors.white, Colors.grey.shade50],
                        ),
                        border:
                            isSelected
                                ? Border.all(
                                  color: themeColors.primary,
                                  width: 2,
                                )
                                : null,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: double.infinity * .9,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: themeColors.primary.withValues(
                                  alpha: isSelected ? 0.2 : 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: isSelected ? 1.1 : 1.0,
                                child: SvgPicture.network(
                                  element.imageUrl,
                                  width: 32.w,
                                  height: 32.h,
                                  colorFilter: ColorFilter.mode(
                                    isSelected
                                        ? themeColors.primary
                                        : themeColors.primary.withValues(
                                          alpha: 0.7,
                                        ),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: AppStyles.font12GreyMedium(
                                context,
                              ).copyWith(
                                color: isSelected ? themeColors.primary : null,
                                fontWeight: isSelected ? FontWeight.w600 : null,
                              ),
                              child: Text(
                                element.duration,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

class SummarySection extends ConsumerWidget {
  const SummarySection(this.cartTotal, {super.key});
  final double cartTotal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryState = ref.watch(deliveryMethodNotifierProvider);

    return deliveryState.when(
      loading: () => const SummarySectionShimmer(),
      error: (err, _) {
        return Column(
          spacing: 14,
          children: <Widget>[
            SummaryPriceTile(title: AppStrings.kOrder, price: cartTotal),
            const SummaryPriceTile(title: AppStrings.kDelivery, price: 0.0),
            SummaryPriceTile(title: AppStrings.kSummary, price: cartTotal),
          ],
        );
      },
      data: (_) {
        // return SummarySectionShimmer();
        final DeliveryMethodEntity? selectedDeliveryMethod = ref.watch(
          selectedDeliveryMethodProvider,
        );

        final double deliveryCost = selectedDeliveryMethod?.cost ?? 0.0;
        final double summary = cartTotal + deliveryCost;

        return Column(
          spacing: 14,
          children: <Widget>[
            SummaryPriceTile(title: AppStrings.kOrder, price: cartTotal),
            SummaryPriceTile(title: AppStrings.kDelivery, price: deliveryCost),
            SummaryPriceTile(title: AppStrings.kSummary, price: summary),
          ],
        );
      },
    );
  }
}
