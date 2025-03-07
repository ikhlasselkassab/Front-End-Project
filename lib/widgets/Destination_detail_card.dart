import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
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
    return Card(
      elevation: 8.0, // Ombre plus prononcée
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bords arrondis
      ),
      margin: EdgeInsets.all(16.0), // Marge autour de la carte
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec le nom de la destination et un bouton de fermeture
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDestinationName(destination),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800], // Couleur de texte plus foncée
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red), // Icône de fermeture en rouge
                  onPressed: onClose,
                ),
              ],
            ),
            SizedBox(height: 10), // Espacement

            // Détails de la destination
            if (destination is Hotel)
              _buildHotelDetails(destination as Hotel),
            if (destination is Restaurant)
              _buildRestaurantDetails(destination as Restaurant),
            if (destination is Station)
              _buildStationDetails(destination as Station),
            if (destination is StationBus)
              _buildBusStationDetails(destination as StationBus),
          ],
        ),
      ),
    );
  }

  // Méthode pour obtenir le nom de la destination
  String _getDestinationName(dynamic destination) {
    if (destination is Hotel) {
      return destination.name;
    } else if (destination is Restaurant) {
      return destination.nom;
    } else if (destination is Station) {
      return destination.name;
    } else if (destination is StationBus) {
      return destination.name;
    } else {
      return 'Destination inconnue';
    }
  }

  // Widget pour afficher les détails d'un hôtel
  Widget _buildHotelDetails(Hotel hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.location_on, 'Adresse', hotel.adresse),
        _buildDetailRow(Icons.star, 'Note', '${hotel.etoiles} étoiles'),
        _buildDetailRow(Icons.attach_money, 'Prix', hotel.description),
      ],
    );
  }

  // Widget pour afficher les détails d'un restaurant
  Widget _buildRestaurantDetails(Restaurant restaurant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.restaurant, 'Cuisine', restaurant.categorie),
        _buildDetailRow(Icons.location_on, 'Adresse', restaurant.adresse),
        _buildDetailRow(Icons.access_time, 'Horaires', restaurant.horaires),
      ],
    );
  }

  // Widget pour afficher les détails d'une station
  Widget _buildStationDetails(Station station) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.train, 'Ligne', station.lat.toString()),
        _buildDetailRow(Icons.location_on, 'Adresse', station.lng.toString()),
      ],
    );
  }

  // Widget pour afficher les détails d'une station de bus
  Widget _buildBusStationDetails(StationBus stationBus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(Icons.directions_bus, 'Ligne', stationBus.lat.toString()),
        _buildDetailRow(Icons.location_on, 'Adresse', stationBus.lng.toString()),
      ],
    );
  }

  // Widget réutilisable pour afficher une ligne de détail avec une icône
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey[600], size: 20), // Icône
          SizedBox(width: 10), // Espacement
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[600], // Couleur de texte
                  ),
                ),
                SizedBox(height: 4), // Espacement
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[800], // Couleur de texte
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