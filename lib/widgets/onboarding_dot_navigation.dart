import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/onboarding_controller.dart';
import '../utils/constants/sizes.dart';


class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller =OnBoardingController.instance;


    return Positioned(
      bottom:kBottomNavigationBarHeight + 25 ,
      left :Sizes.defaultSpace,
      child:  SmoothPageIndicator(
        count: 3,
        controller: controller.pageController ,
        onDotClicked: controller.dotNavigationClick,
        effect: const ExpandingDotsEffect(activeDotColor: const Color(0xFF99E2E5),dotHeight: 6),
      ),
    );
  }
}