// ignore_for_file: avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/Asks/view/Gender.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomSearchFood extends StatefulWidget {
  const CustomSearchFood({Key? key}) : super(key: key);

  @override
  _CustomSearchFoodState createState() => _CustomSearchFoodState();
}

class _CustomSearchFoodState extends State<CustomSearchFood> {
  final TextEditingController _searchController = TextEditingController();
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
                cursorColor: AppColors.button,
                style: TextStyle(color: AppColors.white, fontSize: 18),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Enter your food or drink',
                  hintStyle: TextStyle(color: AppColors.white, fontSize: 18),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: AppColors.button,
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
                    borderSide: BorderSide(color: AppColors.button),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.button),
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
            const Gap(10),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.button,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    _searchResult,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _onAddPressed();
                        test();
                        CaloriesConsumed = storedValue.toString();
                        print("Searched Value: $CaloriesConsumed");
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: _suggestedValues.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _suggestedValues[index],
                      style: TextStyle(color: AppColors.white, fontSize: 18),
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

  List<Map<String, dynamic>> selectedFoods = [];

  Future<void> _search() async {
    String valueToSearch = _searchController.text;

    try {
      // Call the searchByKey function to search for the value in the Firebase Realtime Database
      String? value = await searchByKey(valueToSearch);

      // Update state with the search result
      setState(() {
        if (value != null) {
          _searchResult = 'Every 100 grams of $valueToSearch is : $value';
          selectedFoods.add({"food": valueToSearch, "calories": value});
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
    // Calculate total calories of selected foods
    double totalCalories = selectedFoods.fold(0, (sum, food) {
      // Extract the numeric part of the calories string
      String calories = food['calories'].replaceAll(RegExp(r'[^\d.]'), '');
      // Parse the extracted string as a double
      double parsedCalories = double.parse(calories);
      // Add the parsed calories to the sum
      return sum + parsedCalories;
    });

    // Update CaloriesConsumed
    setState(() {
      CaloriesConsumed = totalCalories.toString();
    });

    // Update Firestore document with the new total
    try {
      DocumentSnapshot snapshot = await users.doc(uid).get();
      Map<String, dynamic> existingData =
          (snapshot.data() as Map<String, dynamic>);
      double existingCalories =
          (existingData['CaloriesConsumed'] ?? 0).toDouble();
      double newCalories = existingCalories + totalCalories;

      Map<String, dynamic> newData = {
        ...existingData,
        "CaloriesConsumed": newCalories,
      };
      await users.doc(uid).set(newData, SetOptions(merge: true));
      print('User updated in Firestore');
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
