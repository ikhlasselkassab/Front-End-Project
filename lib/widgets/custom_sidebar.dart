import 'package:flutter/material.dart';

// Définir un widget Stateless pour la Sidebar
class CustomSidebar extends StatelessWidget {
  // Fonction de callback pour informer le parent des filtres
  final Function(Map<String, bool>) onFilterChanged;

  // Constructeur de CustomSidebar
  CustomSidebar({required this.onFilterChanged});

  // Fonction pour mettre à jour les filtres
  void _onFilterSelected(String filter, bool value) {
    onFilterChanged({filter: value}); // Appeler la fonction callback avec le filtre mis à jour
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête de la sidebar
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Filtres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          // Section Hôtels
          ExpansionTile(
            leading: Icon(Icons.hotel, color: Colors.blue),
            title: Text('Hôtels'),
            children: [
              ListTile(
                title: Text('Hotel 5 Star'),
                onTap: () {
                  _onFilterSelected('Hotel 5 Star', true); // Filtrer Hotel 5 Star
                },
              ),
              ListTile(
                title: Text('Hotel 4 Star'),
                onTap: () {
                  _onFilterSelected('Hotel 4 Star', true); // Filtrer Hotel 4 Star
                },
              ),
              ListTile(
                title: Text('Hotel 3 Star'),
                onTap: () {
                  _onFilterSelected('Hotel 3 Star', true); // Filtrer Hotel 3 Star
                },
              ),
              ListTile(
                title: Text('Hotel 2 Star'),
                onTap: () {
                  _onFilterSelected('Hotel 2 Star', true); // Filtrer Hotel 2 Star
                },
              ),
            ],
          ),

          // Section Restaurants
          ExpansionTile(
            leading: Icon(Icons.restaurant, color: Colors.green),
            title: Text('Restaurants'),
            children: [
              ListTile(
                title: Text('Italien'),
                onTap: () {
                  _onFilterSelected('Restaurant Italien', true); // Filtrer Restaurant Italien
                },
              ),
              ListTile(
                title: Text('Fast Food'),
                onTap: () {
                  _onFilterSelected('Restaurant Fast Food', true); // Filtrer Fast Food
                },
              ),
              ListTile(
                title: Text('Marocain'),
                onTap: () {
                  _onFilterSelected('Restaurant Marocain', true); // Filtrer Marocain
                },
              ),
              ListTile(
                title: Text('Oriental'),
                onTap: () {
                  _onFilterSelected('Restaurant Oriental', true); // Filtrer Oriental
                },
              ),
              ListTile(
                title: Text('Asiatique'),
                onTap: () {
                  _onFilterSelected('Restaurant Asiatique', true); // Filtrer Asiatique
                },
              ),
            ],
          ),

          // Section Bus
          ExpansionTile(
            leading: Icon(Icons.directions_bus, color: Colors.orange),
            title: Text('Bus'),
            children: [
              ListTile(
                title: Text('Ligne 101'),
                onTap: () {
                  _onFilterSelected('Bus Ligne 101', true); // Filtrer Bus Ligne 101
                },
              ),
              ListTile(
                title: Text('Ligne 102'),
                onTap: () {
                  _onFilterSelected('Bus Ligne 102', true); // Filtrer Bus Ligne 102
                },
              ),
              ListTile(
                title: Text('Ligne 104'),
                onTap: () {
                  _onFilterSelected('Bus Ligne 104', true); // Filtrer Bus Ligne 104
                },
              ),
              ListTile(
                title: Text('Ligne 106'),
                onTap: () {
                  _onFilterSelected('Bus Ligne 106', true); // Filtrer Bus Ligne 106
                },
              ),
              ListTile(
                title: Text('Ligne 107'),
                onTap: () {
                  _onFilterSelected('Bus Ligne 107', true); // Filtrer Bus Ligne 107
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
