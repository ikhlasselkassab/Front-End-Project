import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/hotel.dart';

class HotelDialog extends StatelessWidget {
  final Hotel hotel;

  const HotelDialog({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.7,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              hotel.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                hotel.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 15),
            Text(
              '📍 ${hotel.adresse}'+' \n${hotel.quartier}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'ℹ️ ${hotel.description}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}








