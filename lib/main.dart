import 'package:flutter/material.dart';
import 'package:ikhl/screens/map_screen.dart';


void main() {
  runApp(HotelMapApp());
}

class HotelMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte des Hôtels',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HotelMapScreen()
    );
  }
}

