// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_field, unused_local_variable, unused_element

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/features/Asks/view/Gender.dart';
import 'package:diety/features/Auth/SetupPage%20.dart';
import 'package:diety/features/profile/view/contact%20us%20.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/utils/Colors.dart';
import '../../Auth/Login.dart';
import '../../User Plane/view/view/plane.dart';
import '../widget/styles.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  @override
  void initState() {
    super.initState();
    _getUser();
    _getUserdData();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _uid;
  String? _imagePath;
  File? file;
  String? profileUrl;
  String? userID;
  Map<String, dynamic>? userData;
  late String gender = '';
  late String age = '';
  late String height = '';
  late String weight = '';
  late String activity = '';
  late String email = '';
  late String caloriesRemining = '';
  late String dailyCalories = '';
  late String goalweight = '';
  late String waterIntake = '';
  late String sleepDuration = '';
  late String HealthStatus = '';
  late String BMI = '';
  late String idealweight = '';

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
        email = userDoc.get('email');
        height = userDoc.get('height');
        weight = userDoc.get('weight');
        activity = userDoc.get('activity');
        age = userDoc.get('age');
        gender = userDoc.get('gender');
        caloriesRemining = userDoc.get('Calories Remining');
        dailyCalories = userDoc.get('dailyCalories');
        goalweight = userDoc.get('Goal Weight');
        waterIntake = userDoc.get('waterIntake');
        sleepDuration = userDoc.get('sleepDuration');
        HealthStatus = userDoc.get('HealthStatus');
        BMI = userDoc.get('BMI');
        idealweight = userDoc.get('idealWeight');
      });
    }
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedProfileUrl = prefs.getString('profileImageUrl');

    if (storedProfileUrl != null) {
      setState(() {
        profileUrl = storedProfileUrl;
      });
    } else {
      // If profile image URL is not stored locally, fetch it from Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userID = user.uid;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .get();
        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              snapshot.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('image')) {
            setState(() {
              profileUrl = userData['image'] as String?;
            });
          }
        }
      }
    }
  }

  Future<void> updateProfileImage(String newImageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({
          "image": newImageUrl,
        });
        setState(() {
          profileUrl = newImageUrl; // Update profileUrl with new image URL
        });
        print('User profile updated successfully');
      } catch (error) {
        print('Failed to update user profile: $error');
      }
    }
  }

  Future<String> uploadImageToFireStore(File image) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('users/$userID/profileImage.jpg');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageUrl = await uploadImageToFireStore(imageFile);

      setState(() {
        _imagePath = pickedFile.path;
        file = imageFile;
        profileUrl = imageUrl;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userID = user.uid;

        try {
          // Update profile image URL in Firestore
          await updateProfileImage(profileUrl!); // Await here

          // Save profile image URL to local storage
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('profileImageUrl', profileUrl!);

          print('Image updated successfully');
        } catch (error) {
          print('Failed to update  Image: $error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff030b18),
        appBar: AppBar(
          backgroundColor: const Color(0xff151724),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const contactus(),
                ));
              },
              icon: const Icon(
                Icons.message_outlined,
              ),
            )
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Plane(),
                ));
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 30,
              )),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              color: const Color(0xff151724),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) => const SetupPage(),
                            ));
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: (file != null)
                                ? FileImage(file!)
                                : (profileUrl != null)
                                    ? NetworkImage(profileUrl!)
                                    : const AssetImage('Images/person.png')
                                        as ImageProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: getTitleStyle(),
                      ),
                      Text('Mohamed Rifky', style: getbodyStyle()),
                      const Gap(10),
                      Text(FirebaseAuth.instance.currentUser!.email!,
                          style: getsmallStyle()),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(8),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 390,
                      color: const Color(0xff151724),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 10.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Data',
                              style: getTitleStyle(fontSize: 20),
                            ),
                            const Gap(15),
                            Row(
                              children: [
                                Text(
                                  'Activity Level :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  activity,
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Helth Status :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  HealthStatus,
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Age :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  ' ${age.toString()} Years',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Height :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  '$height CM',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Weight :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  '$weight KG',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Gender :',
                                  style: getbodyStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Text(
                                  " $gender",
                                  style: getbodyStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 1.3,
                              color: Colors.white24,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => const Gender(),
                                      ));
                                    },
                                    child: Text(
                                      'Restart And Edit Your Data',
                                      style: getbodyStyle(
                                          fontSize: 18,
                                          color: Colors.blueAccent),
                                    ),
                                  )
                                ])
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      height: 320,
                      color: const Color(0xff151724),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 10.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Goals',
                              style: getTitleStyle(fontSize: 20),
                            ),
                            const Gap(15),
                            Text(
                              'Daily Calories ',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '$dailyCalories Cal',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                            const Gap(15),
                            Text(
                              'Calories Remining ',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '${caloriesRemining.toString()} Cal',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                            const Gap(15),
                            Text(
                              'Ideal Weight',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '$idealweight kg',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                            const Gap(15),
                            Text(
                              'Weekly Goal',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '$goalweight ',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      width: double.infinity,
                      height: 240,
                      color: const Color(0xff151724),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 10.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'More Important Data',
                              style: getTitleStyle(fontSize: 20),
                            ),
                            const Gap(15),
                            Text(
                              'Your BMI ',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              BMI,
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                            const Gap(15),
                            Text(
                              'Water Intake',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '$waterIntake per day',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                            const Gap(15),
                            Text(
                              'Sleep Duration',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            Text(
                              '$sleepDuration Hours',
                              style: getsmallStyle(color: AppColors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(8),
                    InkWell(
                      onTap: () async {
                        GoogleSignIn googleSignIn = GoogleSignIn();
                        googleSignIn.disconnect();
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Login(),
                        ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        color: const Color(0xff151724),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Log out',
                              style: getbodyStyle(fontSize: 18),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.logout,
                                  color: AppColors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
