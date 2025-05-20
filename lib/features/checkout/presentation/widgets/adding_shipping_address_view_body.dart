import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/styled_text_form_field.dart';

class AddingShippingAddressViewBody extends StatefulWidget {
  const AddingShippingAddressViewBody({super.key});

  @override
  State<AddingShippingAddressViewBody> createState() =>
      _AddingShippingAddressViewBodyState();
}

class _AddingShippingAddressViewBodyState
    extends State<AddingShippingAddressViewBody> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _countryController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _zipCodeController = TextEditingController();
    _countryController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 40),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              StyledTextFormField(
                text: AppStrings.kFullName,
                controller: _fullNameController,
              ),
              StyledTextFormField(
                text: AppStrings.kAddress,
                controller: _addressController,
              ),
              StyledTextFormField(
                text: AppStrings.kCity,
                controller: _cityController,
              ),
              StyledTextFormField(
                text: AppStrings.kStateOrProvinceOrRegion,
                controller: _stateController,
              ),
              StyledTextFormField(
                text: AppStrings.kZipCodeOrPostalCode,
                controller: _zipCodeController,
              ),
              StyledTextFormField(
                text: AppStrings.kCountry,
                textInputAction: TextInputAction.done,
                controller: _countryController,
              ),
              SizedBox(height: 5),
              ElevatedButton(
                child: Text(AppStrings.kSaveAddress),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
