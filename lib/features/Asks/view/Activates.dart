import 'package:diety/Core/model/UserInfoProvider.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Container_Activites.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/Asks/view/Age.dart';
import 'package:diety/features/User%20Detials/view/UserDitails.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import 'Gender.dart';

class Activates extends StatefulWidget {
  const Activates({
    super.key,
  }); // Removed duplicate parameter

  @override
  State<Activates> createState() => _ActivatesState();
}

late String activity;
List<bool> isSelected = List.generate(5, (index) => false);

class _ActivatesState extends State<Activates> {
  @override
  void initState() {
    super.initState();
    isSelected = [false, true, false, false, false];
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
              builder: (context) => const Age(),
            ));
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.text,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Countainer_activites(
                  onTap: () {
                    setState(() {
                      isSelected = [true, false, false, false, false];
                    });
                  },
                  color:
                      isSelected[0] ? AppColors.button : AppColors.background,
                  height: 130,
                  title: 'Sedentary 🪑',
                  text: '''
for people who spent most of their time
sitting or lying down ex: Programmer, Bank
Teller, Office Admin'''),
              const Gap(15),
              Countainer_activites(
                onTap: () {
                  setState(() {
                    isSelected = [false, true, false, false, false];
                  });
                },
                color: isSelected[1] ? AppColors.button : AppColors.background,
                height: 150,
                title: 'Lightly Active 🚶',
                text: '''
for people who engage in light physical
activities throughout the day, such as
walking or household chores ex: Teacher
Salesman, school student''',
              ),
              const Gap(15),
              Countainer_activites(
                onTap: () {
                  setState(() {
                    isSelected = [false, false, true, false, false];
                  });
                },
                color: isSelected[2] ? AppColors.button : AppColors.background,
                height: 150,
                title: 'Moderately Active 🏃',
                text: '''
For people who participate in moderate      
physical activities regularly, such as
cycling, or playing sports ex: Personal
Trainer, Waiter University student''',
              ),
              const Gap(15),
              Countainer_activites(
                onTap: () {
                  setState(() {
                    isSelected = [false, false, false, true, false];
                  });
                },
                color: isSelected[3] ? AppColors.button : AppColors.background,
                height: 180,
                title: 'Very Active 🐎',
                text: '''
For people who engage in intense physical
activities on a daily basis, such as high-
intensity workouts, competitive sports, or
physically demanding occupations
ex: Athlete, Construction, Fitness Instructor''',
              ),
              const Gap(15),
              Countainer_activites(
                onTap: () {
                  setState(() {
                    isSelected = [false, false, false, false, true];
                  });
                },
                color: isSelected[4] ? AppColors.button : AppColors.background,
                height: 200,
                title: 'Extra active 🏋️',
                text: '''
For people who have an exceptionally active
lifestyle, involving vigorous physical
activities for extended periods, such as
professional athletes or individuals with
physically demanding jobs ex: policeman,
firefighter''',
              ),
              const SizedBox(height: 20),
              Custom_Button(
                text: 'Continue',
                onPressed: () {
                  test();

                  String selectedActivityLevel = _getSelectedActivityLevel();
                  final userInfoProvider =
                      Provider.of<UserInfoProvider>(context, listen: false);
                  userInfoProvider.updateUserInfo(
                      activity: selectedActivityLevel);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const UserDitails(),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getSelectedActivityLevel() {
    List<String> activityLevels = [
      'Sedentary',
      'Lightly Active',
      'Moderately Active',
      'Very Active',
      'Extra Active',
    ];
    int selectedIndex = isSelected.indexOf(true);
    return activityLevels[selectedIndex];
  }

  Future<void> test() async {
    final String activity = _getSelectedActivityLevel();

    return users
        .doc(uid)
        .update({
          "activity": activity,
        })
        .then((value) => print('User added to Firestore'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}
