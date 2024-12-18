
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/station.dart';

class StationDialog extends StatelessWidget {
  final Station station;

  const StationDialog({required this.station});

  @override
  Widget build(BuildContext context) {
    return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            color: Colors.blue.shade700,
            size: 48,
          ),
          SizedBox(height: 15),
          Text(
            station.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.blue.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '📍 ${station.lat}, ${station.lng}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text('Close'),
          ),
        ],
      ),
    ),
    );
  }
}