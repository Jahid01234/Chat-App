import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  final String hintText;
  final TextEditingController controller;

  const CustomTextFormField({
    super.key,
    this.obscureText,
    this.suffixIcon,
    required this.controller,
    required this.validator,
    required this.keyboardType,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Colors.grey,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.secondary,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 15),
          prefixIcon: Icon(
            prefixIcon,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}