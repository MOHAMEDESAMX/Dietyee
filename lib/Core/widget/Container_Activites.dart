// ignore_for_file: camel_case_types

import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Countainer_activites extends StatelessWidget {
  const Countainer_activites({
    super.key,
    required this.title,
    required this.text,
    required this.height,
    required this.onTap,
    required this.color,
  });
  final String title;
  final String text;
  final double height;
  final Function() onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        height: height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: color,
            border: Border.all(color: AppColors.button, width: 2),
            borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.text, fontSize: 25),
                    children: [
                      TextSpan(text: title),
                    ],
                  ),
                ),
                const Gap(8), // Add some spacing between title and text
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: AppColors.text, fontSize: 17),
                    children: [
                      TextSpan(text: text),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
