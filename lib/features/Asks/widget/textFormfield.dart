// ignore_for_file: camel_case_types

import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';

class textFormField extends StatelessWidget {
  const textFormField({
    super.key,
    // Use Key? instead of super.key
    required this.hintText,
    required this.validator,
    this.onChanged,
    this.onTap,
     this.mycontroller,  // Make this required
  });

  final String hintText;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final TextEditingController? mycontroller;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key, // Assign key here if needed
      onTap: onTap,
      onChanged: onChanged,
      validator: validator,
      controller: mycontroller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: AppColors.text),
      cursorColor: AppColors.button,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 20, color: AppColors.text),
        border: const UnderlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.button),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.button),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
