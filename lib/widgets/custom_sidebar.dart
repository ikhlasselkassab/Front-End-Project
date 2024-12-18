import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomSidebar extends StatelessWidget {
  final Function(Map<String, bool>) onFilterChanged;

  CustomSidebar({required this.onFilterChanged});

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
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_5_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 4 étoiles'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_4_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 3 étoiles'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'hotel_3_star': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Hôtel 2 étoiles'),
                value: false,
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
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_italien': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Fast Food'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_fastfood': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Marocain'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_marocain': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Asiatique'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'restaurant_asiatique': value ?? false});
                },
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Bus'),
            children: [
              CheckboxListTile(
                title: Text('Ligne 101'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_101': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 102'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_102': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 104'),
                value: false,
                onChanged: (bool? value) {
                  onFilterChanged({'bus_line_104': value ?? false});
                },
              ),
              CheckboxListTile(
                title: Text('Ligne 106'),
                value: false,
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