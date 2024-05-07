import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/Auth/Login.dart';
import 'package:diety/features/profile/view/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State {
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imagePath;
  File? file;
  String? profileUrl;

  String? userID;

  Future<void> _getUser() async {
    userID = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<String> uploadImageToFireStore(File image) async {
    setState(() {
      _uploading = true;
    });

    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://dietyapp-c69c7.appspot.com')
            .ref()
            .child('users/${_auth.currentUser!.uid}');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    String url = await ref.getDownloadURL();

    setState(() {
      _uploading = false;
    });

    return url;
  }

  Future<void> _pickImage() async {
    _getUser();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imageUrl = await uploadImageToFireStore(
          imageFile); // Upload image and get URL synchronously

      setState(() {
        _imagePath = pickedFile.path;
        file = imageFile;
        profileUrl = imageUrl; // Assign profileUrl synchronously
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.white, size: 30),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Login(),
              ));
            }),
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          'Add Your Image',
          style: TextStyle(color: AppColors.white, fontSize: 25),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 80,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: (_imagePath != null)
                          ? FileImage(File(_imagePath!)) as ImageProvider
                          : const AssetImage('Images/person.png'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _pickImage();
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.background,
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 25,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_uploading) // Show CircularProgressIndicator if uploading
                CircularProgressIndicator(color: AppColors.button),
              if (!_uploading) // Show Save button if not uploading
                SizedBox(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppColors.button,
                    ),
                    onPressed: () async {
                      await _pickImage();
                      test();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ));
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: AppColors.white, fontSize: 20),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> test() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userID = user.uid;
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .update({
          "email": FirebaseAuth.instance.currentUser!.email,
          "image": profileUrl,
        });
        print('Image added successfully');
      } catch (error) {
        print('Failed to update user profile: $error');
      }
    }
  }
}
