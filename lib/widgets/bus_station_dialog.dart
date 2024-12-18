import 'package:flutter/material.dart';

import '../models/stationBus.dart';


class BusStationDialog extends StatelessWidget {
  final StationBus stationBus;

  const BusStationDialog({required this.stationBus});

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
              stationBus.name,
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
                '📍 ${stationBus.lat}, ${stationBus.lng}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            if (stationBus.lines.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lignes:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...stationBus.lines.map((line) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '- $line',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      )),
                ],
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
