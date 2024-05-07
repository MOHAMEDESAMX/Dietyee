import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class customRowVeiwDitails extends StatelessWidget {
  const customRowVeiwDitails({
    super.key,
    required this.title,
    required this.value,
    this.titlefontSize,
    this.valuefontSize,
  });

  final String title;
  final String value;
  final double? titlefontSize;
  final double? valuefontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            fontSize: titlefontSize ?? 19,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            fontSize: valuefontSize ?? 19,
          ),
        )
      ],
    );
  }
}
