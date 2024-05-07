import 'package:diety/Core/utils/Colors.dart';
import 'package:flutter/material.dart';

TextStyle getTitleStyle(
        {Color? color,
        double? fontSize = 23,
        FontWeight? fontWeight = FontWeight.w800}) =>
    TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.white,
      fontWeight: fontWeight,
    );

TextStyle getbodyStyle(
        {Color? color,
        double? fontSize = 20,
        FontWeight? fontWeight = FontWeight.w500}) =>
    TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.white,
      fontWeight: fontWeight,
    );

TextStyle getsmallStyle(
        {Color? color,
        double? fontSize = 16,
        FontWeight? fontWeight = FontWeight.w500}) =>
    TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.white,
      fontWeight: fontWeight,
    );
