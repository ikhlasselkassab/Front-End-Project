

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ikhl/screens/map_screen.dart';

import '../services/onboarding_controller.dart';
import '../utils/constants/sizes.dart';


// Assuming OnBoardingNextButton is a custom button widget
class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnBoardingController>();  // Use Get.find() to access the controller

    return Positioned(
      bottom: 30,
      right: 30,
      child: ElevatedButton(
        onPressed: (){
      controller.nextPage(context);},// Trigger the nextPage method
        child: Icon(Icons.arrow_forward),
      ),
    );
  }
}


