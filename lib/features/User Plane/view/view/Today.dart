import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/User%20Plane/view/view/plane.dart';
import 'package:flutter/material.dart';

class Today extends StatefulWidget {
  const Today({Key? key}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today",
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Plane(),
              ),
            );
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data: ${snapshot.error}',
                style: TextStyle(color: AppColors.white),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot userData = snapshot.data!.docs[index];

                // Explicitly cast userData.data() to Map<String, dynamic>
                final userDataMap = userData.data() as Map<String, dynamic>?;

                // Check if userDataMap is null or doesn't contain 'users' key
                if (userDataMap == null || !userDataMap.containsKey('users')) {
                  return const ListTile(
                    title: Text('No Username'),
                    subtitle: Text('No Calories Consumed'),
                  );
                }

                final username = userDataMap['users'] ?? 'No Username';
                final CaloriesConsumed = userDataMap['CaloriesConsumed'] ?? 0;

                return ListTile(
                  title: Text(username),
                  subtitle: Text('Total Calories Consumed: $CaloriesConsumed'),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No users or data available'),
            );
          }
        },
      ),
    );
  }
}
