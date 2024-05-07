// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/model/UserInfoProvider.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/Core/widget/Custom_Button.dart';
import 'package:diety/features/Asks/view/Height.dart';
import 'package:diety/features/Auth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Gender extends StatefulWidget {
  const Gender({
    super.key,
  });

  @override
  State<Gender> createState() => _GenderState();
}

late String gender;
bool isMale = true;
CollectionReference users = FirebaseFirestore.instance.collection('users');
String uid = FirebaseAuth.instance.currentUser!.uid;

class _GenderState extends State<Gender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Login(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose your gender.. ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Lottie.asset(('Images/Gender.json')),
              ),
              SizedBox(
                width: 320,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMale = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: AppColors.button, width: 2),
                    backgroundColor:
                        (isMale) ? AppColors.button : AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Male',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Gap(15),
              SizedBox(
                width: 320,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isMale = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: AppColors.button, width: 2),
                    backgroundColor:
                        (!isMale) ? AppColors.button : AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Female',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const Gap(30),
              Custom_Button(
                text: 'Continue',
                onPressed: () {
                  test();

                  final userInfoProvider =
                      Provider.of<UserInfoProvider>(context, listen: false);
                  userInfoProvider.updateUserInfo(
                      gender: isMale ? 'Male' : 'Female');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Height(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }

  Future<void> test() async {
    final String userGender = isMale ? 'Male' : 'Female';
    return users
        .doc(uid)
        .set({
          "email": FirebaseAuth.instance.currentUser!.email,
          "gender": userGender,
        })
        .then((value) => print('user added'))
        .catchError((error) => print(error));
  }
}
