import 'package:flutter/material.dart';

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
  });

  final bool isPassword;
  final String text;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final List<String>? autofillHints;

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

      decoration: InputDecoration(
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
                : null,
      ),
    );
  }
}
