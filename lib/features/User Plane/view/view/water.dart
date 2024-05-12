import 'package:flutter/material.dart';

class WaterGlass extends StatelessWidget {
  final int glasses;
  final bool filled;
  final VoidCallback onTap;

  const WaterGlass({
    Key? key,
    required this.glasses,
    required this.filled,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: filled ? 100 : 20,
            decoration: BoxDecoration(
              color: filled ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: Center(
              child: Text(
                '$glasses',
                style: TextStyle(
                  color: filled ? Colors.white : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (glasses > 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onTap,
            ),
        ],
      ),
    );
  }
}

class MyWaterPage extends StatefulWidget {
  const MyWaterPage({Key? key}) : super(key: key);

  @override
  _MyWaterPageState createState() => _MyWaterPageState();
}

class _MyWaterPageState extends State<MyWaterPage> {
  List<bool> filledGlasses = [false];

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Water Tracker'),
    ),
    body: Center(
      child: Column(
        children: [
          for (int i = 0; i < filledGlasses.length; i++)
            WaterGlass(
              glasses: i + 1,
              filled: filledGlasses[i],
              onTap: () {
                setState(() {
                  // Create a new empty glass
                  filledGlasses.add(false);
                  // Fill the tapped glass
                  filledGlasses[i] = true;
                });
              },
            ),
        ],
      ),
    ),
  );
}
}


