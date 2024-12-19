import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/map_screen.dart';

class OnBoardingController extends GetxController {

  static OnBoardingController get instance => Get.find();




  //variables
  final pageController =PageController();
  Rx<int> curretPageIndex=0.obs;

  //update Current index when page scroll
  void updatePageIndicator(index)=> curretPageIndex.value=index;

  //jump to the specific dot selected page 
  void dotNavigationClick(index){
    curretPageIndex.value=index;
    pageController.jumpTo(index);
  }

  //update Current Index & jump to the next Page
  void nextPage(BuildContext context) {
    if (curretPageIndex.value == 2) {
      print("Navigating to HotelMapScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HotelMapScreen()),
      );  // Use Navigator to push the HotelMapScreen
    } else {
      int page = curretPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }



  //update Current Index & jump to the last Page
   void skipPage(){
    curretPageIndex.value=2;
    pageController.jumpToPage(2);
   }


}