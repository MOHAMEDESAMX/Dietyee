import 'package:diety/Core/model/UserInfo.dart';
import 'package:flutter/material.dart';
// Adjust the path as per your project structure

class UserInfoProvider extends ChangeNotifier {
  // Define a private variable to store the user information
  UserInfo _userInfo = UserInfo(
    gender: '',
    height: 0,
    weight: 0,
    age: 0,
    activity: '',
  );

  // Create a getter to access the user information
  UserInfo get userInfo => _userInfo;
  double get caloriseRemining => _caloriseRemining;
  double _caloriseRemining = 0;
  String _caloriesConsumed = '';
  String get caloriesConsumed => _caloriesConsumed;

  // Method to update the user information
  void updateUserInfo({
    String? gender,
    double? height,
    double? weight,
    double? age,
    String? activity,
  }) {
    // Update only the fields that are not null
    _userInfo = UserInfo(
      gender: gender ?? _userInfo.gender,
      height: height ?? _userInfo.height,
      weight: weight ?? _userInfo.weight,
      age: age ?? _userInfo.age,
      activity: activity ?? _userInfo.activity,
    );

    // Notify listeners that the user information has changed
    notifyListeners();
  }

  // Method to update CaloriseRemining in UserInfo model

  void updateCaloriseRemining(double value) {
    _caloriseRemining = value;
    notifyListeners();
  }

  void updateCaloriesConsumed(String value) {
    _caloriesConsumed = value;
    notifyListeners();
  }
}
