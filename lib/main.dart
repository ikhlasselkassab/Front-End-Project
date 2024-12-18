import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikhl/stationTrame-service.dart';
import 'package:ikhl/widgets/custom_sidebar.dart';
import 'package:latlong2/latlong.dart';
import 'hotel-service.dart';
import 'restaurant-service.dart';
import 'stationBus-service.dart';

void main() {
  runApp(HotelMapApp());
}

class HotelMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carte des Hôtels',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HotelMapScreen()
    );
  }
}

class HotelMapScreen extends StatefulWidget {
  @override
  _HotelMapScreenState createState() => _HotelMapScreenState();
}

class _HotelMapScreenState extends State<HotelMapScreen> {
  // Données
  List<Marker> _markers = [];
  List<Hotel> _hotels = [];
  List<Restaurant> _restaurants = [];
  List<StationBus> _stationsBus = [];

  // Filtres supplémentaires
  bool _filterHotels5Star = false;
  bool _filterHotels4Star = false;
  bool _filterHotels3Star = false;
  bool _filterHotels2Star = false;

  bool _filterRestaurantsItalien = false;
  bool _filterRestaurantsFastFood = false;
  bool _filterRestaurantsMarocain = false;
  bool _filterRestaurantsOriental = false;
  bool _filterRestaurantsAsiatique = false;

  bool _filterBusLine101 = false;
  bool _filterBusLine102 = false;
  bool _filterBusLine104 = false;
  bool _filterBusLine106 = false;
  bool _filterBusLine107 = false;

  @override
  void initState() {
    super.initState();
    loadHotels();
    loadRestaurants();
    loadBusStations();
  }

  Future<void> loadHotels() async {
    try {
      final hotels = await HotelService.fetchHotels();
      setState(() {
        _hotels = hotels;
        _markers.addAll(_hotels.map((hotel) {
          return Marker(
            point: LatLng(hotel.latitude, hotel.longitude),
            builder: (ctx) => GestureDetector(
              onTap: () => _showHotelDetails(hotel),
              child: Icon(Icons.hotel, color: Colors.redAccent, size: 15),
            ),
          );
        }).toList());
      });
    } catch (error) {
      print('Error loading hotels: $error');
    }
  }


  Future<void> loadRestaurants() async {
    try {
      final restaurants = await RestaurantService.fetchRestaurants();
      setState(() {
        _restaurants = restaurants;

        _markers.addAll(_restaurants.map((restaurant) {
          return Marker(
            point: LatLng(restaurant.latitude, restaurant.longitude),
            builder: (ctx) => GestureDetector(
              onTap: () => _showRestaurantDetails(restaurant),
              child: Icon(Icons.restaurant, color: Colors.purple, size: 15),
            ),
          );
        }).toList());
      });
    } catch (error) {
      print('Error loading restaurants: $error');
    }
  }
  Future<void> loadBusStations() async {
    try {
      final stationsBus = await StationBusService.fetchBusStations();
      setState(() {
        _stationsBus = stationsBus;

        _markers.addAll(_stationsBus.map((station) {
          return Marker(
            point: LatLng(station.lat, station.lng),
            builder: (ctx) => GestureDetector(
              onTap: () => _showBusStationDetails(station),
              child: Icon(Icons.directions_bus, color: Colors.greenAccent, size: 15),
            ),
          );
        }).toList());
      });
    } catch (error) {
      print('Error loading bus stations: $error');
    }
  }

  void _showBusStationDetails(StationBus stationBus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue.shade700,
                  size: 48,
                ),
                SizedBox(height: 15),
                Text(
                  stationBus.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '📍 ${stationBus.lat}, ${stationBus.lng}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                if (stationBus.lines.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lignes:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...stationBus.lines.map((line) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          '- $line',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      )),
                    ],
                  ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  restaurant.nom,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.orange.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),

                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    restaurant.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),

                // Adresse
                Text(
                  '📍 Adresse: ${restaurant.adresse}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Téléphone
                Text(
                  '📞 Téléphone: ${restaurant.numero_de_telephone}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                // Catégorie
                Text(
                  '📋 Catégorie: ${restaurant.categorie}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  '⏰ Horaires: ${restaurant.horaires}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),

              ],
            ),
          ),
        );
      },
    );
  }



  void _showHotelDetails(Hotel hotel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hotel.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    hotel.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  '📍 ${hotel.adresse}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'ℹ️ ${hotel.description}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),

              ],
            ),
          ),
        );
      },
    );
  }
  void _showStationDetails(Station station) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue.shade700,
                  size: 48,
                ),
                SizedBox(height: 15),
                Text(
                  station.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '📍 ${station.lat}, ${station.lng}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // Mise à jour des marqueurs selon les filtres
  void _updateMarkers() {
    List<Marker> markers = [];

    // Si aucun filtre n'est activé, on affiche tous les marqueurs
    if (!_filterHotels5Star && !_filterHotels4Star && !_filterHotels3Star && !_filterHotels2Star &&
        !_filterRestaurantsItalien && !_filterRestaurantsFastFood && !_filterRestaurantsMarocain && !_filterRestaurantsOriental && !_filterRestaurantsAsiatique &&
        !_filterBusLine101 && !_filterBusLine102 && !_filterBusLine104 && !_filterBusLine106 && !_filterBusLine107) {
      // Ajouter tous les hôtels
      _hotels.forEach((hotel) {
        markers.add(Marker(
          point: LatLng(hotel.latitude, hotel.longitude),
          builder: (ctx) => GestureDetector(
            child: Icon(Icons.hotel, color: Colors.redAccent, size: 15),
          ),
        ));
      });

      // Ajouter tous les restaurants
      _restaurants.forEach((restaurant) {
        markers.add(Marker(
          point: LatLng(restaurant.latitude, restaurant.longitude),
          builder: (ctx) => GestureDetector(
            child: Icon(Icons.restaurant, color: Colors.purple, size: 15),
          ),
        ));
      });

      // Ajouter toutes les stations de bus
      _stationsBus.forEach((station) {
        markers.add(Marker(
          point: LatLng(station.lat, station.lng),
          builder: (ctx) => GestureDetector(
            child: Icon(Icons.directions_bus, color: Colors.green, size: 15),
          ),
        ));
      });
    }

    // Appliquer les filtres si activés

    // Filtrer les hôtels
    if (_filterHotels5Star || _filterHotels4Star || _filterHotels3Star || _filterHotels2Star) {
      _hotels.forEach((hotel) {
        if ((_filterHotels5Star && hotel.etoiles == 5) ||
            (_filterHotels4Star && hotel.etoiles == 4) ||
            (_filterHotels3Star && hotel.etoiles == 3) ||
            (_filterHotels2Star && hotel.etoiles == 2)) {
          markers.add(Marker(
            point: LatLng(hotel.latitude, hotel.longitude),
            builder: (ctx) => GestureDetector(
              child: Icon(Icons.hotel, color: Colors.redAccent, size: 35),
            ),
          ));
        }
      });
    }

    // Filtrer les restaurants
    if (_filterRestaurantsItalien || _filterRestaurantsFastFood || _filterRestaurantsMarocain || _filterRestaurantsOriental || _filterRestaurantsAsiatique) {
      _restaurants.forEach((restaurant) {
        if ((_filterRestaurantsItalien && restaurant.categorie == 'Italien') ||
            (_filterRestaurantsFastFood && restaurant.categorie == 'Fast Food') ||
            (_filterRestaurantsMarocain && restaurant.categorie == 'Marocain') ||
            (_filterRestaurantsOriental && restaurant.categorie == 'Oriental') ||
            (_filterRestaurantsAsiatique && restaurant.categorie == 'Asiatique')) {
          markers.add(Marker(
            point: LatLng(restaurant.latitude, restaurant.longitude),
            builder: (ctx) => GestureDetector(
              child: Icon(Icons.restaurant, color: Colors.purple, size: 35),
            ),
          ));
        }
      });
    }

    // Filtrer les stations de bus
    if (_filterBusLine101 || _filterBusLine102 || _filterBusLine104 || _filterBusLine106 || _filterBusLine107) {
      _stationsBus.forEach((station) {
        if ((_filterBusLine101 && station.lines.contains("L101")) ||
            (_filterBusLine102 && station.lines.contains("L102")) ||
            (_filterBusLine104 && station.lines.contains("L104")) ||
            (_filterBusLine106 && station.lines.contains("L106")) ||
            (_filterBusLine107 && station.lines.contains("L107"))) {
          markers.add(Marker(
            point: LatLng(station.lat, station.lng),
            builder: (ctx) => GestureDetector(
              child: Icon(Icons.directions_bus, color: Colors.greenAccent, size: 35),
            ),
          ));
        }
      });
    }

    setState(() {
      _markers = markers; // Mise à jour des marqueurs affichés
    });
  }

  // Fonction appelée lorsque l'utilisateur change un filtre
  void _onFilterChanged(Map<String, bool> filters) {
    setState(() {
      _filterHotels5Star = filters['hotel_5_star'] ?? false;
      _filterHotels4Star = filters['hotel_4_star'] ?? false;
      _filterHotels3Star = filters['hotel_3_star'] ?? false;
      _filterHotels2Star = filters['hotel_2_star'] ?? false;

      _filterRestaurantsItalien = filters['restaurant_italien'] ?? false;
      _filterRestaurantsFastFood = filters['restaurant_fastfood'] ?? false;
      _filterRestaurantsMarocain = filters['restaurant_marocain'] ?? false;
      _filterRestaurantsOriental = filters['restaurant_oriental'] ?? false;
      _filterRestaurantsAsiatique = filters['restaurant_asiatique'] ?? false;

      _filterBusLine101 = filters['bus_line_101'] ?? false;
      _filterBusLine102 = filters['bus_line_102'] ?? false;
      _filterBusLine104 = filters['bus_line_104'] ?? false;
      _filterBusLine106 = filters['bus_line_106'] ?? false;
      _filterBusLine107 = filters['bus_line_107'] ?? false;
    });

    _updateMarkers(); // Met à jour les marqueurs après changement de filtre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte des Hôtels'),
      ),
      drawer: CustomSidebar(onFilterChanged: _onFilterChanged),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(34.0, -6.8),
                zoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

