// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/model/UserInfoProvider.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/Asks/view/Activates.dart';
import 'package:diety/features/Asks/view/Gender.dart';
import 'package:diety/features/User%20Detials/widget/viewDitails.dart';
import 'package:diety/features/User%20Goals/view/wishes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

var userInfo;

class UserDitails extends StatefulWidget {
  const UserDitails({super.key});

  @override
  State<UserDitails> createState() => _UserDitailsState();
}

String gender = '';
String age = '0'; // Initialize with a default value
String height = '0'; // Initialize with a default value
String weight = '0'; // Initialize with a default value
String activity = '';
String bmi = '0';
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
late String _uid;

class _UserDitailsState extends State<UserDitails> {
  @override
  void initState() {
    super.initState();
    _getUserdData();
  }

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
        height =
            userDoc.get('height') ?? '0'; // Use default value if height is null
        weight =
            userDoc.get('weight') ?? '0'; // Use default value if weight is null
        activity = userDoc.get('activity') ??
            ''; // Use default value if activity is null
        age = userDoc.get('age') ?? '0'; // Use default value if age is null
        gender =
            userDoc.get('gender') ?? ''; // Use default value if gender is null
        bmi = userDoc.get('BMI') ?? '0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context).userInfo;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Body Details',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.white,
            fontSize: 25,
          ),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Activates(),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(
                //     width: 300,
                //     height: 280,
                //     child: Lottie.asset(
                //       'Images/Ditails_Animation.json',
                //     )),
                CircularPercentIndicator(
                  animationDuration: 1800,
                  animation: true,
                  radius: 100,
                  lineWidth: 22,
                  percent: double.parse(calculateBMI().toString()) / 100,
                  progressColor: AppColors.button,
                  backgroundColor: AppColors.grey,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    "${calculateBMI().toStringAsFixed(1)}%",
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30),
                  ),
                ),

                const Gap(10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       gender,
                //       style: TextStyle(color: AppColors.white),
                //     ),
                //     Text(height.toString(),
                //         style: TextStyle(color: AppColors.white)),
                //     Text(weight.toString(),
                //         style: TextStyle(color: AppColors.white)),
                //     Text(activity, style: TextStyle(color: AppColors.white)),
                //     Text(age.toString(),
                //         style: TextStyle(color: AppColors.white))
                //   ],
                // ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                        " Health Status is  ${calculateAndDetermineBMI().toString()}",
                        textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white),
                        speed: const Duration(milliseconds: 100)),
                  ],
                  totalRepeatCount: 1,
                  stopPauseOnTap: true,
                  displayFullTextOnTap: true,
                ),
                const Gap(10),
                customRowVeiwDitails(
                  title: 'Your daily calorie needed :',
                  value: dailyCalories.toStringAsFixed(1),
                ),
                const Gap(15),
                customRowVeiwDitails(
                  title: 'Your (BMI) :',
                  value: calculateBMI().toStringAsFixed(1),
                ),
                const Gap(15),
                // customRowVeiwDitails(
                //   title: 'Health Status :',
                //   value: calculateAndDetermineBMI().toString(),
                //   valuefontSize: 17,
                // ),
                // const Gap(15),
                customRowVeiwDitails(
                  title: 'Ideal Weight :',
                  value: '${calculateIdealWeight().toStringAsFixed(1)} kg',
                ),
                const Gap(15),
                customRowVeiwDitails(
                  title: 'Water Intake :',
                  value: '${calculateWaterIntake().toStringAsFixed(1)} L',
                ),
                const Gap(15),
                customRowVeiwDitails(
                  title: 'Optimal Sleep Duration :',
                  value: '${calculateOptimalSleepDuration()} hrs',
                ),
                const Gap(15),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.button.withOpacity(0.4),
                        AppColors.button.withOpacity(0.5),
                        AppColors.button.withOpacity(1),
                      ],
                      stops: const [0.0, 0.75, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Advice For You !",
                          style: TextStyle(
                              color: AppColors.white,
                              decoration: TextDecoration.underline,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        Text(
                          showDetailedAdvice(
                              double.parse(calculateBMI().toString())),
                          style:
                              TextStyle(color: AppColors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(40),
                Custom_Button(
                    width: 300,
                    text: 'My Plane',
                    onPressed: () {
                      String idealweight =
                          calculateIdealWeight().toStringAsFixed(1);
                      String waterIntake =
                          calculateWaterIntake().toStringAsFixed(1);
                      String sleepDuration =
                          calculateOptimalSleepDuration().toString();

                      String HealthStatus =
                          calculateAndDetermineBMI().toString();
                      double daily = userInfo.dailyCalories;
                      String BMI = calculateBMI().toStringAsFixed(1);
                      test(daily, BMI, idealweight, waterIntake, sleepDuration,
                          HealthStatus);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Wishes(),
                      ));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> test(double daily, String BMI, String idealweight,
      String waterIntake, String sleepDuration, String HealthStatus) async {
    return users
        .doc(uid)
        .update({
          "dailyCalories": dailyCalories.toString(),
          'BMI': BMI,
          'idealWeight': idealweight,
          'waterIntake': waterIntake,
          'sleepDuration': sleepDuration,
          'HealthStatus': HealthStatus,
        })
        .then((value) => print('User added to Firestore $dailyCalories'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  double calculateBMR() {
    double bmr = 0.0;
    try {
      if (gender == 'Male') {
        bmr = ((10 * int.parse(weight)) +
                (6.25 * int.parse(height)) -
                (5 * int.parse(age))) +
            5;
      } else {
        bmr = ((10 * int.parse(weight)) +
                (6.25 * int.parse(height)) -
                (5 * int.parse(age))) -
            161;
      }
    } catch (e) {
      print('Error calculating BMR: $e');
    }
    return bmr;
  }

  double get dailyCalories {
    double bmr = calculateBMR();
    double activityFactor = getActivityFactor();
    double calories = bmr * activityFactor;

    return calories;
  }
   
  // Method to get activity factor based on activity level
  
  double getActivityFactor() {
    double activityFactor = 1; // Default activity factor
    switch (activity) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly Active':
        activityFactor = 1.375;
        break;
      case 'Moderately Active':
        activityFactor = 1.55;
        break;
      case 'Very Active':
        activityFactor = 1.725;
        break;
      case 'Extra Active':
        activityFactor = 1.9;
        break;
    }
    return activityFactor;
  }

  double calculateBMI() {
    try {
      double heightInMeter =
          int.parse(height) / 100; // Convert height from cm to m
      double bmi = int.parse(weight) / (heightInMeter * heightInMeter);
      return bmi;
    } catch (e) {
      print('Error calculating BMI: $e');
      return 0.0; // Or any default value you prefer
    }
  }

  String calculateAndDetermineBMI() {
    // Formula for BMI: weight (kg) / (height (m) * height (m))
    double heightInMeter =
        int.parse(height) / 100; // Convert height from cm to m
    double bmi = int.parse(weight) / (heightInMeter * heightInMeter);

    // Determine BMI category
    if (bmi < 16.0) {
      return 'Severely Underweight';
    } else if (bmi >= 16.0 && bmi < 16.9) {
      return 'Underweight';
    } else if (bmi >= 17.0 && bmi < 18.4) {
      return 'Mildly Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal Weight';
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return 'Overweight';
    } else if (bmi >= 30.0 && bmi < 34.9) {
      return 'Obesity class I';
    } else if (bmi >= 35.0 && bmi < 39.9) {
      return 'Obesity class II';
    } else {
      return 'Obesity class III';
    }
  }

  String showDetailedAdvice(double bmi) {
    if (bmi < 16.0) {
      return "Severely Underweight. It's critical to seek medical attention immediately. Rapid weight loss can indicate serious health issues. Consult with a healthcare professional to address underlying causes and develop a safe and effective plan for weight gain.";
    } else if (bmi >= 16.0 && bmi < 16.9) {
      return "Underweight. Although not severely underweight, it's essential to address any unintentional weight loss. Focus on increasing calorie intake through balanced meals and snacks. Incorporate strength training exercises to build muscle mass and improve overall health.";
    } else if (bmi >= 17.0 && bmi < 18.4) {
      return "Mildly Underweight. While not severely underweight, it's important to pay attention to nutrition and overall health. Aim for a balanced diet rich in nutrient-dense foods and consider consulting with a dietitian to develop a personalized eating plan.";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return "Normal Weight. Congratulations on maintaining a healthy weight! Continue to prioritize healthy eating habits and regular physical activity to support overall well-being.";
    } else if (bmi >= 25.0 && bmi < 29.9) {
      return "Overweight. It's important to focus on gradual weight loss to reduce health risks associated with excess weight. Incorporate more fruits, vegetables, and whole grains into your diet, and aim for at least 150 minutes of moderate-intensity exercise per week.";
    } else if (bmi >= 30.0 && bmi < 34.9) {
      return "Obesity class I. Take proactive steps to manage your weight and improve your health. Work with a healthcare professional to develop a comprehensive plan that includes dietary changes, increased physical activity, and behavior modification strategies.";
    } else if (bmi >= 35.0 && bmi < 39.9) {
      return "Obesity class II. This is a serious health condition requiring professional intervention. Consideration of medical treatments, such as medication or bariatric surgery, may be necessary. Seek guidance from healthcare providers specializing in obesity management.";
    } else {
      return "Obesity class III. Also known as morbid obesity, this is a severe health condition requiring urgent medical attention. Immediate intervention is necessary to reduce the risk of associated health complications. Consult with healthcare specialists experienced in managing severe obesity.";
    }
  }

  // Method to calculate ideal weight for men
  double calculateIdealWeightForMen() {
    // Ideal weight formula for men: 48 + 1.1 * (height in cm - 150)
    return 48 + 1.1 * (int.parse(height) - 150);
  }

  // Method to calculate ideal weight for women
  double calculateIdealWeightForWomen() {
    // Ideal weight formula for women: 45 + 0.9 * (height in cm - 150)
    return 45 + 0.9 * (int.parse(height) - 150);
  }

  // Method to determine ideal weight based on gender
  double calculateIdealWeight() {
    if (gender == 'Male') {
      return calculateIdealWeightForMen();
    } else {
      return calculateIdealWeightForWomen();
    }
  }

  double calculateWaterIntake() {
    double baseWaterIntake = 30;
    double adjustedWaterIntake = baseWaterIntake;
    switch (activity) {
      case 'Sedentary':
        adjustedWaterIntake *= 1.0;
        break;
      case 'Lightly Active':
        adjustedWaterIntake *= 1.1;
        break;
      case 'Moderately Active':
        adjustedWaterIntake *= 1.2;
        break;
      case 'Very Active':
        adjustedWaterIntake *= 1.3;
        break;
      case 'Extra Active':
        adjustedWaterIntake *= 1.4;
        break;
      default:
        adjustedWaterIntake *= 1.0;
    }

    double recommendedWaterIntakeInMl = adjustedWaterIntake * int.parse(weight);
    double recommendedWaterIntakeInLiters = recommendedWaterIntakeInMl / 1000;

    return recommendedWaterIntakeInLiters;
  }

  // Method to calculate optimal sleep duration
  String calculateOptimalSleepDuration() {
    // Define sleep duration recommendations based on age groups
    if (int.parse(age) <= 12) {
      return '9-12';
    } else if (int.parse(age) <= 19) {
      return '8-10';
    } else if (int.parse(age) <= 64) {
      return '7-9';
    } else {
      return '7-8';
    }
  }
}
