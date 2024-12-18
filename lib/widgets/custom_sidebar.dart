import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatelessWidget {
  final Function(Map<String, bool>) onFilterChanged;


  final bool filterHotels5Star;
  final bool filterHotels4Star;
  final bool filterHotels3Star;
  final bool filterHotels2Star;

  final bool filterRestaurantsItalien;
  final bool filterRestaurantsFastFood;
  final bool filterRestaurantsMarocain;
  final bool filterRestaurantsAsiatique;
  final bool filterRestaurantsOriental;

  final bool filterLine1;
  final bool filterLine2;

  final bool filterBusLine101;
  final bool filterBusLine102;
  final bool filterBusLine104;
  final bool filterBusLine106;
  final bool filterBusLine107;

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
    required this.filterRestaurantsOriental,
    required this.filterBusLine107,
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
              ListTile(
                title: Text('Hôtel 5 étoiles'),
                onTap: () {
                  onFilterChanged({'hotel_5_star': true});
                },
              ),
              ListTile(
                title: Text('Hôtel 4 étoiles'),
                onTap: () {
                  onFilterChanged({'hotel_4_star': true});
                },
              ),
              ListTile(
                title: Text('Hôtel 3 étoiles'),
                onTap: () {
                  onFilterChanged({'hotel_3_star': true});
                },
              ),
              ListTile(
                title: Text('Hôtel 2 étoiles'),
                onTap: () {
                  onFilterChanged({'hotel_2_star': true});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Restaurants'),
            children: [
              ListTile(
                title: Text('Italien'),
                onTap: () {
                  onFilterChanged({'restaurant_italien': true});
                },
              ),
              ListTile(
                title: Text('Fast Food'),
                onTap: () {
                  onFilterChanged({'restaurant_fastfood': true});
                },
              ),
              ListTile(
                title: Text('Marocain'),
                onTap: () {
                  onFilterChanged({'restaurant_marocain': true});
                },
              ),
              ListTile(
                title: Text('Oriental'),
                onTap: () {
                  onFilterChanged({'restaurant_oriental': true});
                },
              ),
              ListTile(
                title: Text('Asiatique'),
                onTap: () {
                  onFilterChanged({'restaurant_asiatique': true});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Stations de Tramway'),
            children: [
              ListTile(
                title: Text('Ligne 1'),
                onTap: () {
                  onFilterChanged({'line_1': true});
                },
              ),
              ListTile(
                title: Text('Ligne 2'),
                onTap: () {
                  onFilterChanged({'line_2': true});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Bus'),
            children: [
              ListTile(
                title: Text('Ligne 101'),
                onTap: () {
                  onFilterChanged({'bus_line_101': true});
                },
              ),
              ListTile(
                title: Text('Ligne 102'),
                onTap: () {
                  onFilterChanged({'bus_line_102': true});
                },
              ),
              ListTile(

                title: Text('Ligne 104'),
                onTap: () {
                  onFilterChanged({'bus_line_104': true});
                },
              ),
              ListTile(
                title: Text('Ligne 107'),
                onTap: () {
                  onFilterChanged({'bus_line_107': true});
                },
              ),
              ListTile(
                title: Text('Ligne 106'),
                onTap: () {
                  onFilterChanged({'bus_line_106': true});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
