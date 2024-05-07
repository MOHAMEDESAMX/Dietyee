import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;

import '../../../../Core/utils/Colors.dart';
import 'plane.dart';

class Exercise extends StatefulWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  _ExerciseState createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  late double _predictionResult; // Change the type to List<dynamic>
  bool _isLoading = false;
  String gender = '';
  String age = '0';
  String height = '0';
  String weight = '0';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _uid;

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
    _getUserdData();
  }

  Future<void> _getUserdData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_uid).get();
      setState(() {
        height = userDoc.get('height') ?? '0';
        weight = userDoc.get('weight') ?? '0';

        age = userDoc.get('age') ?? '0';
        gender = userDoc.get('gender') ?? '';
      });
    }
  }

Future<void> _fetchPrediction() async {
  setState(() {
    _isLoading = true;
  });

  var url = Uri.parse('http://10.0.2.2:5000/predict');
  var data = {
    'Weight': [weight],
    'Height': [height],
    'Gender': [gender],
    'Age': [age]
  };

  try {
    var jsonData = jsonEncode(data);
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    );

    if (mounted) { // Check if the widget is still mounted
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var predictions = decodedResponse['predictions'];
        if (predictions is List && predictions.isNotEmpty) {
          setState(() {
            _predictionResult = predictions[0].toDouble();
          });
        } else {
          setState(() {
            _predictionResult = 0;
          });
        }
      } else {
        setState(() {
          _predictionResult = 0;
        });
      }
    }
  } catch (error) {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _predictionResult = 0;
      });
    }
  } finally {
    if (mounted) { // Check if the widget is still mounted
      setState(() {
        _isLoading = false;
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exercise',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const Plane(),
              ));
            },
            icon: Icon(Icons.arrow_back, color: AppColors.white)),
      ),
      body: Center(
        child: Column(
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Text(
                        "$_predictionResult"), // Convert the list to a string for display
                  ),
            Row(
              children: [
                Text('Age: $age '),
                const Gap(10),
                Text(' Height:$height'),
                const Gap(10),
                Text('Weight: $weight'),
                const Gap(10),
                Text('Gender: $gender'),
                const Gap(10),
              ],
            )
          ],
        ),
      ),
    );
  }
}
