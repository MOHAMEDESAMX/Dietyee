import 'package:diety/Core/model/UserInfoProvider.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/Asks/view/Age.dart';
import 'package:diety/features/Asks/view/Height.dart';
import 'package:diety/features/Asks/widget/textFormfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Gender.dart';

class Weight extends StatefulWidget {
  const Weight({Key? key}) : super(key: key);

  @override
  State<Weight> createState() => _WeightState();
}

late String weight;

class _WeightState extends State<Weight> {
  TextEditingController weightController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Height(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.text,
            size: 30,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "What's your Weight ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 290,
                  child: Image(image: AssetImage('Images/weight.jpg')),
                ),
                textFormField(
                  onChanged: (value) {
                    final userInfoProvider =
                        Provider.of<UserInfoProvider>(context, listen: false);
                    userInfoProvider.updateUserInfo(
                        weight: double.tryParse(value!) ?? 0.0);
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Weight';
                    } else {
                      final weight = double.tryParse(value);
                      if (weight == null || weight > 400 || weight <= 20) {
                        return 'Please Enter A Valid Weight';
                      }
                    }
                    return null;
                  },
                  hintText: 'Enter your Weight',
                  mycontroller: weightController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Custom_Button(
                  text: 'Continue',
                  onPressed: () { 
                    if (formKey.currentState!.validate()) {
                      weight = weightController.text;
                      test();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const Age(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> test( ) async {
    return users
        .doc(uid)
        .update({
          "email": FirebaseAuth.instance.currentUser!.email,
          "weight": weight,
        })
        .then((value) => print('User added to Firestore'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}
