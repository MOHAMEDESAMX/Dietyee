// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/User%20Goals/Widget/Container_Goal.dart';
import 'package:diety/features/User%20Goals/view/wishes.dart';
import 'package:diety/features/User%20Plane/view/view/plane.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../Asks/view/Gender.dart';

class gain_Weight extends StatefulWidget {
  const gain_Weight({super.key});

  @override
  State<gain_Weight> createState() => _gain_WeightState();
}

List<bool> isSelected = List.generate(4, (index) => false);

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late String _uid;
String daily = '';
double CaloriseRemining = 0.0;

class _gain_WeightState extends State<gain_Weight> {
  Future<void> _getUserdData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });

      // Query Firestore for the user document using UID
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_uid).get();
      setState(() {
        daily = userDoc.get('dailyCalories');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserdData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Wishes(),
              ));
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.text,
              size: 30,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'What is your weekly goal',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.white,
                fontSize: 30,
              ),
            ),
            const Gap(60),
            Container_Goal(
              onTap: () {
                setState(() {
                  isSelected = [true, false, false, false];
                  CaloriseRemining = double.parse(daily) + 250;
                  print(CaloriseRemining.toInt());
                });
              },
              color: isSelected[0] ? AppColors.button : AppColors.background,
              text: 'Gain 0.25 Kg per week',
            ),
            const Gap(15),
            Container_Goal(
              onTap: () {
                setState(() {
                  isSelected = [false, true, false, false];
                  CaloriseRemining = double.parse(daily) + 500;
                  print(CaloriseRemining.toInt());
                });
              },
              color: isSelected[1] ? AppColors.button : AppColors.background,
              text: 'Gain 0.5 Kg per week (Recommended)',
            ),
            const Gap(15),
            Container_Goal(
              onTap: () {
                setState(() {
                  isSelected = [false, false, true, false];
                  CaloriseRemining = double.parse(daily) + 750;
                });
              },
              color: isSelected[2] ? AppColors.button : AppColors.background,
              text: 'Gain 0.75 Kg per week',
            ),
            const Gap(15),
            Container_Goal(
              onTap: () {
                setState(() {
                  isSelected = [false, false, false, true];
                  CaloriseRemining = double.parse(daily) + 1000;
                });
              },
              color: isSelected[3] ? AppColors.button : AppColors.background,
              text: 'Gain 1 Kg per week',
            ),
            const Gap(40),
            Custom_Button(
                width: double.infinity,
                text: 'Continue',
                onPressed: () {
                  if (isSelected.contains(true)) {
                    test();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const Plane(),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Please Select Your Goal'),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<void> test() async {
    String curantData = '';
    if (isSelected[0]) {
      curantData = 'Gain 0.25 Kg per week';
    } else if (isSelected[1]) {
      curantData = 'Gain 0.5 Kg per week';
    } else if (isSelected[2]) {
      curantData = 'Gain 0.75 Kg per week';
    } else if (isSelected[3]) {
      curantData = 'Gain 1 Kg per week';
    }

    return users
        .doc(uid)
        .update({
          "Calories Remining": CaloriseRemining.toString(),
          "Goal Weight": curantData,
        })
        .then((value) => print('Calories Remining added to Firestore'))
        .catchError(
            (error) => print('Failed to add Calories Remining: $error'));
  }
}
