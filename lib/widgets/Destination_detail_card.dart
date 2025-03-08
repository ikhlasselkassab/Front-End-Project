import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/stationBus.dart';

class DestinationDetailsCard extends StatelessWidget {
  final dynamic destination;
  final VoidCallback onClose;

  const DestinationDetailsCard({
    required this.destination,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDestinationName(destination),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent.withOpacity(0.8),
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (destination is Hotel) _buildHotelDetails(destination as Hotel),
            if (destination is Restaurant) _buildRestaurantDetails(destination as Restaurant),
            if (destination is StationBus) _buildBusStationDetails(destination as StationBus),
            if (destination is Map<String, dynamic>) _buildStaticDetails(destination),
          ],
        ),
      ),
    );
  }

  String _getDestinationName(dynamic destination) {
    if (destination is Hotel) return destination.name;
    if (destination is Restaurant) return destination.nom;
    if (destination is StationBus) return destination.name;
    if (destination is Map<String, dynamic>) return destination['nom'] ?? 'Destination inconnue';
    return 'Destination inconnue';
  }

  Widget _buildHotelDetails(Hotel hotel) {
    return _buildDetailSection([
      _buildImage(hotel.image),
      _buildDetailRow(Icons.location_on, 'Adresse', hotel.adresse),
      _buildDetailRow(Icons.star, 'Note', '${hotel.etoiles} étoiles'),
      _buildDetailRow(Icons.info_outline, 'Description', hotel.description),
    ]);
  }

  Widget _buildRestaurantDetails(Restaurant restaurant) {
    return _buildDetailSection([
      _buildImage(restaurant.image),
      _buildDetailRow(Icons.restaurant, 'Cuisine', restaurant.categorie),
      _buildDetailRow(Icons.location_on, 'Adresse', restaurant.adresse),
      _buildDetailRow(Icons.access_time, 'Horaires', restaurant.horaires),
    ]);
  }

  Widget _buildBusStationDetails(StationBus stationBus) {
    return _buildDetailSection([
      _buildDetailRow(Icons.directions_bus, 'Nom', stationBus.name),
      _buildDetailRow(Icons.location_on, 'Latitude', stationBus.lat.toString()),
      _buildDetailRow(Icons.location_on, 'Longitude', stationBus.lng.toString()),
    ]);
  }

  Widget _buildStaticDetails(Map<String, dynamic> data) {
    return _buildDetailSection([
      _buildDetailRow(Icons.location_on, 'Nom', data['nom']),
      if (data.containsKey('adresse')) _buildDetailRow(Icons.location_on, 'Adresse', data['adresse']),
      if (data.containsKey('capacite')) _buildDetailRow(Icons.people, 'Capacité', '${data['capacite']} personnes'),
    ]);
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDetailSection(List<Widget> details) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        children: details,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
