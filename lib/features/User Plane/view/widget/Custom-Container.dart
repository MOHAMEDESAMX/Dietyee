// ignore: camel_case_types

import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.onTap,
    required this.iconData1,
    this.iconData2,
    required this.text,
    this.color,
    required this.iconColor,
    required this.style,
  }) : super(key: key);

  final Function() onTap;
  final IconData iconData1;
  final IconData? iconData2;
  final String text;
  final Color? color;
  final Color iconColor;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.button, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                iconData1,
                color: iconColor,
                size: 30,
              ),
              const Gap(15),
              Text(text, style: style),
              const Spacer(),
              Icon(
                iconData2,
                color: AppColors.button,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
