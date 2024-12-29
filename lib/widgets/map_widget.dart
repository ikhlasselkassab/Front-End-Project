import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final List<Marker> markers;
  final List<LatLng> routeCoordinates;
   final MapController mapController; 

  const MapWidget({
    required this.markers,
    required this.routeCoordinates,
       required this.mapController, 
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController, 
      options: MapOptions(
        center: LatLng(34.0, -6.8),
        zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
        if (routeCoordinates.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: routeCoordinates,
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ],
          ),
      ],
    );
  }
}
