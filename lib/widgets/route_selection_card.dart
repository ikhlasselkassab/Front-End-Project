import 'package:flutter/material.dart';

class RouteSelectionCard extends StatelessWidget {
  final List<String> destinations;
  final Function(String?) onStartPointSelected;
  final Function(String?) onEndPointSelected;
  final VoidCallback onClose;
  final VoidCallback onFetchRoute;

  RouteSelectionCard({
    required this.destinations,
    required this.onStartPointSelected,
    required this.onEndPointSelected,
    required this.onClose,
    required this.onFetchRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // En-tête de la carte avec un bouton de fermeture
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sélectionnez votre itinéraire',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: onClose, // Fermer le Dialog
              ),
            ],
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            hint: Text('Point de départ'),
            items: ['Position actuelle', ...destinations].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onStartPointSelected,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            hint: Text('Point d\'arrivée'),
            items: destinations.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onEndPointSelected,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onClose,
                child: Text('Fermer'),
              ),
              ElevatedButton(
                onPressed: onFetchRoute,
                child: Text('Valider'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}