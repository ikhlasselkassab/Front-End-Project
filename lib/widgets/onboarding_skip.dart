import 'package:flutter/material.dart';


import '../services/onboarding_controller.dart';
import '../utils/constants/sizes.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(top:kToolbarHeight, right: Sizes.defaultSpace, 
    child:TextButton(onPressed: ()=>OnBoardingController.instance.skipPage(),
    child: const Text( "Skip",  style: TextStyle(  color: Color.fromARGB(255, 154, 140, 93),
     fontWeight: FontWeight.bold, // Couleur personnalisée
    ),
     )
    ));
  }
}
