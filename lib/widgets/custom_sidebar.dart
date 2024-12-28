import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final Function(Map<String, bool>) onFilterChanged;
  final Map<String, bool> filters;

  CustomSidebar({
    required this.onFilterChanged,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF2CBFD7), // Updated color
            ),
            child: Text(
              'Filtres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildExpansionTile(
            title: 'Hôtels',
            options: {
              'hotel_5_star': 'Hôtel 5 étoiles',
              'hotel_4_star': 'Hôtel 4 étoiles',
              'hotel_3_star': 'Hôtel 3 étoiles',
              'hotel_2_star': 'Hôtel 2 étoiles',
            },
          ),
          _buildExpansionTile(
            title: 'Restaurants',
            options: {
              'restaurant_italien': 'Italien',
              'restaurant_fastfood': 'Fast Food',
              'restaurant_marocain': 'Marocain',
              'restaurant_oriental': 'Oriental',
              'restaurant_asiatique': 'Asiatique',
            },
          ),
          _buildExpansionTile(
            title: 'Stations de Tramway',
            options: {
              'line_1': 'Ligne 1',
              'line_2': 'Ligne 2',
            },
          ),
          _buildExpansionTile(
            title: 'Bus',
            options: {
              'bus_line_101': 'Ligne 101',
              'bus_line_102': 'Ligne 102',
              'bus_line_104': 'Ligne 104',
              'bus_line_106': 'Ligne 106',
              'bus_line_107': 'Ligne 107',
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required Map<String, String> options,
  }) {
    return ExpansionTile(
      title: Text(title),
      children: options.entries.map((entry) {
        return CheckboxListTile(
          title: Text(entry.value),
          value: filters[entry.key] ?? false,
          onChanged: (bool? value) {
            onFilterChanged({entry.key: value ?? false});
          },
        );
      }).toList(),
    );
  }
}
