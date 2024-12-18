import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final Function(Map<String, bool>) onFilterChanged;

  // Les filtres actuels sont transmis depuis le parent
  final bool filterHotels5Star;
  final bool filterHotels4Star;
  final bool filterHotels3Star;
  final bool filterHotels2Star;

  final bool filterRestaurantsItalien;
  final bool filterRestaurantsFastFood;
  final bool filterRestaurantsMarocain;
  final bool filterRestaurantsAsiatique;

  final bool filterLine1;
  final bool filterLine2;

  final bool filterBusLine101;
  final bool filterBusLine102;
  final bool filterBusLine104;
  final bool filterBusLine106;

  // Constructeur
  CustomSidebar({
    required this.onFilterChanged,
    required this.filterHotels5Star,
    required this.filterHotels4Star,
    required this.filterHotels3Star,
    required this.filterHotels2Star,
    required this.filterRestaurantsItalien,
    required this.filterRestaurantsFastFood,
    required this.filterRestaurantsMarocain,
    required this.filterRestaurantsAsiatique,
    required this.filterLine1,
    required this.filterLine2,
    required this.filterBusLine101,
    required this.filterBusLine102,
    required this.filterBusLine104,
    required this.filterBusLine106,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Text(
              'Filtres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ExpansionTile(
            title: Text('Hôtels'),
            children: [
              CheckboxListTile(
                title: Text('Hôtel 5 étoiles'),
                value: filterHotels5Star,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_5_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 4 étoiles'),
                value: filterHotels4Star,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_4_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 3 étoiles'),
                value: filterHotels3Star,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_3_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 2 étoiles'),
                value: filterHotels2Star,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_2_star': value ?? false});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Restaurants'),
            children: [
              CheckboxListTile(
                title: Text('Italien'),
                value: filterRestaurantsItalien,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_italien': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Fast Food'),
                value: filterRestaurantsFastFood,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_fastfood': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Marocain'),
                value: filterRestaurantsMarocain,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_marocain': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Asiatique'),
                value: filterRestaurantsAsiatique,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_asiatique': value ?? false});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Stations de Tramway'),
            children: [
              CheckboxListTile(
                title: Text('Ligne 1'),
                value: filterLine1,
                onChanged: (bool? value) {
                  onFilterChanged({'line_1': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 2'),
                value: filterLine2,
                onChanged: (bool? value) {
                  onFilterChanged({'line_2': value ?? false});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Bus'),
            children: [
              CheckboxListTile(
                title: Text('Ligne 101'),
                value: filterBusLine101,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_101': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 102'),
                value: filterBusLine102,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_102': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 104'),
                value: filterBusLine104,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_104': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 106'),
                value: filterBusLine106,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_106': value ?? false});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
