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
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _buildExpansionTile(
                    title: 'Hôtels',
                    icon: Icons.bed,
                    options: {
                      'hotel_5_star': 'Hôtel 5 étoiles',
                      'hotel_4_star': 'Hôtel 4 étoiles',
                      'hotel_3_star': 'Hôtel 3 étoiles',
                      'hotel_2_star': 'Hôtel 2 étoiles',
                    },
                  ),
                  _buildExpansionTile(
                    title: 'Restaurants',
                    icon: Icons.local_dining,
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
                    icon: Icons.tram,
                    options: {
                      'line_1': 'Ligne 1',
                      'line_2': 'Ligne 2',
                    },
                  ),
                  _buildExpansionTile(
                    title: 'Bus',
                    icon: Icons.directions_bus,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list,
            size: 36,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          Text(
            'Filtres',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required Map<String, String> options,
  }) {
    return ExpansionTile(
      leading: Icon(
        icon,
        color: Colors.blueGrey[700],
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      children: options.entries.map((entry) {
        return CheckboxListTile(
          title: Text(
            entry.value,
            style: TextStyle(fontSize: 14),
          ),
          value: filters[entry.key] ?? false,
          onChanged: (bool? value) {
            onFilterChanged({entry.key: value ?? false});
          },
          activeColor: Colors.blueGrey[900],
          checkColor: Colors.white,
        );
      }).toList(),
    );
  }
}
