import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Container_Goal extends StatelessWidget {
  const Container_Goal({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });
  final String text;
  final Function() onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: AppColors.button, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Row(
              children: [
                RichText(
                    text: TextSpan(
                        style: const TextStyle(fontSize: 20),
                        children: [
                      TextSpan(
                          text: text, style: TextStyle(color: AppColors.text))
                    ])),
              ],
            ),
          )),
    );
  }
}
