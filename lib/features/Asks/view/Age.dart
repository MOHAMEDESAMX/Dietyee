import 'package:diety/Core/model/UserInfoProvider.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/Asks/view/Activates.dart';
import 'package:diety/features/Asks/view/Weight.dart';
import 'package:diety/features/Asks/widget/textFormfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Gender.dart';

class Age extends StatefulWidget {
  const Age({Key? key}) : super(key: key);

  @override
  State<Age> createState() => _AgeState();
}

late String age;

class _AgeState extends State<Age> {
  TextEditingController ageController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Create an instance of UserInputModel to store user input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Weight(),
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
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "What's your age ?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 290,
                  child: Image(image: AssetImage('Images/age.jpg')),
                ),
                textFormField(
                  onChanged: (value) {
                    final userInfoProvider =
                        Provider.of<UserInfoProvider>(context, listen: false);
                    userInfoProvider.updateUserInfo(
                        age: double.tryParse(value!) ?? 0.0);
                    return null;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Age';
                    } else {
                      final age = double.tryParse(value);
                      if (age == null || age > 70) {
                        return 'Please Enter A Valid Age';
                      } else if (age <= 18) {
                        return 'You should be at least 18 years old';
                      }
                    }
                    return null;
                  },
                  hintText: 'Enter Your age',
                  mycontroller: ageController,
                ),
                const SizedBox(
                  height: 30,
                ),
                Custom_Button(
                  text: 'Continue',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      age = ageController.text;
                      test();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Activates(),
                      ));
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

  Future<void> test() async {
    return users
        .doc(uid)
        .update({
          "email": FirebaseAuth.instance.currentUser!.email,
          "age": age,
        })
        .then((value) => print('User added to Firestore'))
        .catchError((error) => print('Failed to add user: $error'));
  }
}
