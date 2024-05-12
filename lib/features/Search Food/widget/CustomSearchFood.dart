// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/Asks/view/Gender.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomSearchFood extends StatefulWidget {
  const CustomSearchFood({Key? key}) : super(key: key);

  @override
  _CustomSearchFoodState createState() => _CustomSearchFoodState();
}

class _CustomSearchFoodState extends State<CustomSearchFood> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _gramsController = TextEditingController(); // Add this line to initialize _gramsController
  String _searchResult = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> _suggestedValues = [];
  bool _isKeyboardVisible = false;
  String CaloriesConsumed = '';
    String? storedValue;


  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _onAddPressed();
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _searchController.dispose();
    _gramsController.dispose(); // Add this line to dispose _gramsController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(
              height: _searchController.text.isEmpty ? 50.0 : 70.0,
              width: double.infinity,
              child: TextFormField(
                onChanged: (value) {
                  _filterValues(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your food ';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                cursorColor: Colors.blue,
                style: TextStyle(color: Colors.black, fontSize: 18),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter your food or drink',
                  hintStyle: TextStyle(color: Colors.black, fontSize: 18),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _search();
                      }
                    },
                  ),
                  border: const UnderlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
                focusNode: FocusNode()..addListener(_onFocusChange),
              ),
            ),
            ElevatedButton(
              onPressed: () => _showGramsBottomSheet(context),
              child: Text('Enter Grams'),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              height: 60,
              width: double.infinity,
              color: Colors.blue,
              child: Text(
                _searchResult,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestedValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _suggestedValues[index],
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      _searchController.text = _suggestedValues[index];
                      _search();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGramsBottomSheet(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Grams',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _gramsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Grams',
                hintText: 'Enter grams',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Call search method here passing grams as parameter
                _search();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> selectedFoods = [];

Future<void> _search() async {
  String food = _searchController.text;
  double grams = double.tryParse(_gramsController.text) ?? 100; // Default to 100 grams if invalid input

  try {
    // Call the searchByKey function to search for the value in the Firebase Realtime Database
    String? value = await searchByKey(food);

    // Update state with the search result
    setState(() {
      if (value != null) {
        double calories = calculateCalories(value, grams);
        _searchResult = '$grams grams of $food is: $calories calories';
        selectedFoods.add({"food": food, "calories": calories});
      } else {
        _searchResult = 'Value not found.';
      }
    });
  } catch (error) {
    // Handle any errors that occur during data retrieval
    print('Error retrieving data: $error');
    setState(() {
      _searchResult = 'Error retrieving data. Please try again later.';
    });
  }
}

double calculateCalories(String value, double grams) {
  // Parse the value retrieved from the database and calculate calories based on grams
  double parsedValue = double.tryParse(value.replaceAll('cal', '').trim()) ?? 0;
  return parsedValue * (grams / 100);
}


  Future<String?> searchByKey(String key) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    try {
      // Use a DatabaseEvent instead of a DataSnapshot
      DatabaseEvent event = await ref.once();

      // Access the DataSnapshot from the DatabaseEvent
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        // Cast snapshot value to Map<dynamic, dynamic>
        Map<dynamic, dynamic>? values =
            snapshot.value as Map<dynamic, dynamic>?;

        if (values != null) {
          // Iterate through all child nodes
          for (var entry in values.entries) {
            // Get the key and value
            String entryKey = entry.key.toString();
            String entryValue = entry.value.toString();

            // Check if the key matches the search term (case-insensitive)
            if (entryKey.substring(0, 1).toUpperCase() ==
                    key.substring(0, 1).toUpperCase() &&
                entryKey.substring(1) == key.substring(1)) {
              // Return the value if the key matches
              return entryValue;
            }
          }
        } else {
          print('Snapshot value is not a Map');
        }
      } else {
        // Handle the case when snapshot value is null
        print('Snapshot value is null');
      }
    } catch (error) {
      // Handle errors
      print('Error searching by key: $error');
    }

    return null; // Return null if key is not found or if an error occurs
  }

  void _filterValues(String query) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref();

    try {
      DatabaseEvent event = await ref.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? values =
            snapshot.value as Map<dynamic, dynamic>?;
        if (values != null) {
          List<String> suggestions = [];
          for (var entry in values.entries) {
            String entryKey = entry.key.toString();
            if (entryKey.toLowerCase().contains(query.toLowerCase())) {
              suggestions.add(entryKey);
            }
          }
          setState(() {
            _suggestedValues = suggestions;
          });
        } else {
          print('Snapshot value is not a Map');
        }
      } else {
        print('Snapshot value is null');
      }
    } catch (error) {
      print('Error filtering values: $error');
    }
  }

  void _onSearchTextChanged() {
    _filterValues(_searchController.text);
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = !_isKeyboardVisible;
      // Clear suggestions when keyboard is visible
      if (_isKeyboardVisible) {
        _suggestedValues.clear();
      }
    });
  }

void _onAddPressed() async {
  // Retrieve the grams entered by the user
  double grams = double.tryParse(_gramsController.text) ?? 100.0; // Default to 100 grams if parsing fails

  // Calculate total calories of selected foods based on the grams entered by the user
  double totalCalories = selectedFoods.fold(0, (sum, food) {
    // Extract the numeric part of the calories string
    String calories = food['calories'].replaceAll(RegExp(r'[^\d.]'), '');
    // Parse the extracted string as a double
    double parsedCalories = double.parse(calories);
    // Calculate calories based on grams entered by the user
    double caloriesForGrams = (parsedCalories / 100) * grams;
    // Add the calculated calories to the sum
    return sum + caloriesForGrams;
  });

  // Update CaloriesConsumed
  setState(() {
    CaloriesConsumed = totalCalories.toString();
  });

  // Update Firestore document with the new total
  try {
    // Your Firestore update logic here...
  } catch (error) {
    print('Failed to update user: $error');
  }
}

  Future<void> test() async {
    try {
      // Remove the "cal" part from storedValue
      String? valueWithoutCal = storedValue?.replaceAll('cal', '').trim();

      if (valueWithoutCal != null && valueWithoutCal.isNotEmpty) {
        // Convert the value to a double
        double parsedValue = double.parse(valueWithoutCal);

        // Update CaloriesConsumed
        setState(() {
          CaloriesConsumed = parsedValue.toString();
        });

        // Get the current document snapshot to preserve existing data
        DocumentSnapshot snapshot = await users.doc(uid).get();
        // Extract the existing data, cast to Map<String, dynamic>
        Map<String, dynamic> existingData =
            (snapshot.data() as Map<String, dynamic>);

        // Merge the existing data with the new data
        Map<String, dynamic> newData = {
          ...existingData,
          "CaloriesConsumed": parsedValue,
        };

        // Update the document with the merged data
        await users.doc(uid).set(newData, SetOptions(merge: true));

        print('User updated in Firestore');
      } else {
        print('Value is empty or not valid');
      }
    } catch (error) {
      print('Failed to update user: $error');
    }
  }
}
