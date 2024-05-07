// ignore_for_file: camel_case_types

import 'package:community_material_icon/community_material_icon.dart';
import 'package:diety/Core/utils/Colors.dart';
import 'package:diety/features/User%20Plane/view/view/plane.dart';
import 'package:diety/features/profile/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../../Search Food/view/Breakfast.dart';
import '../../../Search Food/view/Dinner.dart';

class salomon_bottom_bar extends StatefulWidget {
  const salomon_bottom_bar({Key? key}) : super(key: key);

  @override
  _salomon_bottom_barState createState() => _salomon_bottom_barState();
}

class _salomon_bottom_barState extends State<salomon_bottom_bar> {
  int _currentIndex = 0;
  final List _pages = [
    const Plane(),
    const Breakfast(),
    const Dinner(),
    const Profile(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: SalomonBottomBar(
        backgroundColor: AppColors.background,
        currentIndex: _currentIndex,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => _pages[index],
          ));
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(
              CommunityMaterialIcons.view_dashboard,
              size: 30,
            ),
            title: const Text("Diary"),
            selectedColor: AppColors.button,
            unselectedColor: AppColors.white,
          ),
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.utensils),
            title: const Text("Recipes"),
            selectedColor: AppColors.button,
            unselectedColor: AppColors.white,
          ),
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.personRunning),
            title: const Text("Plans"),
            selectedColor: AppColors.button,
            unselectedColor: AppColors.white,
          ),
          SalomonBottomBarItem(
            icon: const Icon(FontAwesomeIcons.user),
            title: const Text("Profile"),
            selectedColor: AppColors.button,
            unselectedColor: AppColors.white,
          )
        ],
      ),
    );
  }
}
