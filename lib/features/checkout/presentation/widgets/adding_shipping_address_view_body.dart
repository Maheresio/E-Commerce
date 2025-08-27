import '../../domain/entities/shipping_address_entity.dart';
import '../controller/shipping_address/shipping_address_providers.dart';
import '../utils/shipping_address_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/styled_text_form_field.dart';

class AddingShippingAddressViewBody extends HookWidget {
  const AddingShippingAddressViewBody(this.address, {super.key});

  final ShippingAddressEntity? address;

  @override
  Widget build(BuildContext context) {
    final TextEditingController fullNameController = useTextEditingController(
      text: address?.name ?? '',
    );
    final TextEditingController addressController = useTextEditingController(
      text: address?.street ?? '',
    );
    final TextEditingController cityController = useTextEditingController(
      text: address?.city ?? '',
    );
    final TextEditingController stateController = useTextEditingController(
      text: address?.state ?? '',
    );
    final TextEditingController zipCodeController = useTextEditingController(
      text: address?.zipCode ?? '',
    );
    final TextEditingController countryController = useTextEditingController(
      text: address?.country ?? '',
    );
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 40),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: <Widget>[
              StyledTextFormField(
                text: AppStrings.kFullName,
                controller: fullNameController,
                validator: ShippingAddressValidators.validateFullName,
              ),
              StyledTextFormField(
                text: AppStrings.kAddress,
                controller: addressController,
                validator: ShippingAddressValidators.validateAddress,
              ),
              StyledTextFormField(
                text: AppStrings.kCity,
                controller: cityController,
                validator: ShippingAddressValidators.validateCity,
              ),
              StyledTextFormField(
                text: AppStrings.kStateOrProvinceOrRegion,
                controller: stateController,
                validator: ShippingAddressValidators.validateState,
              ),
              StyledTextFormField(
                text: AppStrings.kZipCodeOrPostalCode,
                controller: zipCodeController,
                keyboardType: TextInputType.text,
                validator: ShippingAddressValidators.validateZipCode,
              ),
              StyledTextFormField(
                text: AppStrings.kCountry,
                textInputAction: TextInputAction.done,
                controller: countryController,
                validator: ShippingAddressValidators.validateCountry,
              ),
              const SizedBox(height: 5),
              Consumer(
                builder:
                    (
                      BuildContext context,
                      WidgetRef ref,
                      Widget? child,
                    ) => ElevatedButton(
                      child: const Text(AppStrings.kSaveAddress),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (address != null) {
                            await ref
                                .read(shippingAddressNotifierProvider.notifier)
                                .updateAddress(
                                  ShippingAddressEntity(
                                    id: address!.id,
                                    name: fullNameController.text,
                                    street: addressController.text,
                                    city: cityController.text,
                                    state: stateController.text,
                                    zipCode: zipCodeController.text,
                                    country: countryController.text,
                                  ),
                                );
                          } else {
                            await ref
                                .read(shippingAddressNotifierProvider.notifier)
                                .addAddress(
                                  ShippingAddressEntity(
                                    id: const Uuid().v4(),
                                    name: fullNameController.text,
                                    street: addressController.text,
                                    city: cityController.text,
                                    state: stateController.text,
                                    zipCode: zipCodeController.text,
                                    country: countryController.text,
                                  ),
                                );
                          }
                          if (context.mounted) context.pop();
                        }
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
