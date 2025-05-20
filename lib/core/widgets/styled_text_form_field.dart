import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_styles.dart';

class StyledTextFormField extends StatefulWidget {
  const StyledTextFormField({
    super.key,
    required this.text,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    required this.controller,
    this.validator,
    this.isPassword = false,
    this.autofillHints,
    this.suffixIcon,
  });

  final bool isPassword;
  final String text;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<String>? autofillHints;
  final Widget? suffixIcon;

  @override
  State<StyledTextFormField> createState() => _StyledTextFormFieldState();
}

class _StyledTextFormFieldState extends State<StyledTextFormField> {
  bool _isPasswordVisible = false;
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      obscureText: widget.isPassword && !_isPasswordVisible,
      keyboardType: widget.keyboardType,
      style: AppStyles.font14BlackMedium,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        labelText: widget.text,

        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
                : widget.suffixIcon,
      ),
    );
  }
}
