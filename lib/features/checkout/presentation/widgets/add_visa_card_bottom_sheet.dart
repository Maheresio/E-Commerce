import '../../domain/entities/visa_card_entity.dart';
import '../controller/visa_card/visa_card_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/styled_text_form_field.dart';
import '../utils/payment_card_validators.dart';
import 'shipping_check_box.dart';

class AddVisaCardBottomSheet extends HookWidget {
  const AddVisaCardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = useTextEditingController();
    final TextEditingController cardNumberController = useTextEditingController();
    final TextEditingController expireDateController = useTextEditingController();
    final TextEditingController securityCodeController = useTextEditingController();
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);
    final ValueNotifier<bool> isDefault = useState(false);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 16.w,
        bottom: MediaQuery.of(context).viewInsets.bottom * .7 + 20,
      ),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: <Widget>[
              Text(
                AppStrings.kAddNewCard,
                style: AppStyles.font18BlackSemiBold(context),
              ),
              StyledTextFormField(
                text: AppStrings.kNameOnCard,
                controller: nameController,
                validator: PaymentCardValidators.validateNameOnCard,
                textCapitalization: TextCapitalization.words,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
              ),
              StyledTextFormField(
                text: AppStrings.kCardNumber,
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                validator: PaymentCardValidators.validateCardNumber,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  _CardNumberInputFormatter(),
                ],
                suffixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: SvgPicture.asset(AppImages.mastercard),
                ),
              ),
              StyledTextFormField(
                text: AppStrings.kExpireDate,
                controller: expireDateController,
                keyboardType: TextInputType.number,
                validator: PaymentCardValidators.validateExpireDate,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  _ExpiryDateInputFormatter(),
                ],
              ),
              StyledTextFormField(
                text: AppStrings.kSecurityCodeHint,
                controller: securityCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: PaymentCardValidators.validateSecurityCode,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              StyledCheckbox(
                text: AppStrings.kUseAsDefaultPaymentMethod,
                isChecked: isDefault.value,
                onChanged: (bool? val) {
                  isDefault.value = val ?? false;
                },
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(visaCardLoadingState)
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            ref.read(visaCardLoadingState.notifier).state =
                                true;

                            await _addCard(
                              ref: ref,
                              cardNumberController: cardNumberController,
                              expireDateController: expireDateController,
                              securityCodeController: securityCodeController,
                              nameController: nameController,
                              isDefault: isDefault.value,
                            );
                            ref.read(visaCardLoadingState.notifier).state =
                                false;
                            if (context.mounted) {
                              context.pop();
                            }
                          }
                        },
                        child: Text(AppStrings.kAddCard),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addCard({
    required WidgetRef ref,
    required TextEditingController cardNumberController,
    required TextEditingController expireDateController,
    required TextEditingController securityCodeController,
    required TextEditingController nameController,
    required bool isDefault,
  }) async {
    final String customerId =
        await ref.read(visaCardNotifierProvider.notifier).getOrCreateCustomer();

    await Stripe.instance.dangerouslyUpdateCardDetails(
      CardDetails(
        number: cardNumberController.text,
        expirationMonth: int.parse(expireDateController.text.split('/')[0]),
        expirationYear: int.parse(expireDateController.text.split('/')[1]),
        cvc: securityCodeController.text,
      ),
    );
    final TokenData cardToken = await Stripe.instance.createToken(
      CreateTokenParams.card(
        params: CardTokenParams(
          name: nameController.text,
          currency: 'usd',
        ),
      ),
    );
    final String paymentMethod = await ref
        .read(visaCardNotifierProvider.notifier)
        .addCard(
          customerId: customerId,
          cardToken: cardToken.id,
          card: VisaCardEntity(
            id: cardToken.id,

            holderName: nameController.text,
            last4: cardNumberController.text.substring(
              cardNumberController.text.length - 4,
            ),
            expMonth: expireDateController.text.split('/')[1],
            expYear: expireDateController.text.split('/')[0],
          ),
        );

    if (isDefault) {
      await ref
          .read(visaCardNotifierProvider.notifier)
          .setDefaultCard(
            customerId: customerId,
            paymentMethodId: paymentMethod,
          );
    }
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text.replaceAll(' ', '');
    final StringBuffer buffer = StringBuffer();

    for (var i = 0; i < newText.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(newText[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String newText = newValue.text;

    if (newText.length <= 2) {
      return newValue;
    }

    final String month = newText.substring(0, 2);
    final String year = newText.substring(2);

    return TextEditingValue(
      text: '$month/$year',
      selection: TextSelection.collapsed(offset: '$month/$year'.length),
    );
  }
}
