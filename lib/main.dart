import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ikhl/stationTrame-service.dart';
import 'package:ikhl/widgets/custom_sidebar.dart';
import 'package:latlong2/latlong.dart';
import 'Destination-service.dart';
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

  List<Marker> _markers = [];
  List<Hotel> _hotels = [];
  List<Restaurant> _restaurants = [];
  List<StationBus> _stationsBus = [];
  List<Station> _stations = [];
  List<LatLng> _routeCoordinates = [];
  List<String> _destinations = [];

  String? _selectedDestination;


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

  bool _filterLine1 = false;
  bool _filterLine2 = false;

  @override
  void initState() {
    super.initState();
    loadHotels();
    loadRestaurants();
    loadBusStations();
    loadStations();
    loadDestinations();
  }

  Future<void> loadHotels() async {
    try {
      final hotels = await HotelService.fetchHotels();
      setState(() {
        _hotels = hotels;
        _markers.addAll(_hotels.map((hotel) {
          return Marker(
            point: LatLng(hotel.latitude, hotel.longitude),
            builder: (ctx) =>
                GestureDetector(
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
            builder: (ctx) =>
                GestureDetector(
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

  Future<void> loadStations() async {
    try {
      final stations = await StationTrameService.fetchStations();
      setState(() {
        _stations = stations;
        _markers.addAll(_stations.map((station) {
          return Marker(
            point: LatLng(station.lat, station.lng),
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showStationDetails(station),
                  child: Icon(Icons.train, color: Colors.blueAccent, size: 15),
                ),
          );
        }).toList());
      });
    } catch (error) {
      print('Error loading stations: $error');
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
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showBusStationDetails(station),
                  child: Icon(Icons.directions_bus, color: Colors.greenAccent,
                      size: 15),
                ),
          );
        }).toList());
      });
    } catch (error) {
      print('Error loading bus stations: $error');
    }
  }

  Future<void> loadDestinations() async {
    try {
      final destinations = await DestinationService.fetchAllDestinations();
      setState(() {
        _destinations = destinations;
      });
    } catch (e) {
      _showSnackBar('Erreur lors du chargement des destinations.');
    }
  }

  Future<void> fetchRouteToSelectedDestination() async {
    if (_selectedDestination == null) {
      _showSnackBar('Veuillez sélectionner une destination.');
      return;
    }

    try {
      // Identifier si la destination est un hôtel ou une station
      final isHotel = _hotels.any((hotel) =>
      hotel.name == _selectedDestination);
      final isStation = _stations.any((station) =>
      station.name == _selectedDestination);

      if (!isHotel && !isStation) {
        _showSnackBar('Destination inconnue.');
        return;
      }

      // Obtenir la position actuelle de l'utilisateur
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng destinationCoordinates;
      if (isHotel) {
        final destinationHotel = _hotels.firstWhere((hotel) =>
        hotel.name == _selectedDestination);
        destinationCoordinates =
            LatLng(destinationHotel.latitude, destinationHotel.longitude);
      } else {
        final destinationStation = _stations.firstWhere((station) =>
        station.name == _selectedDestination);
        destinationCoordinates =
            LatLng(destinationStation.lat, destinationStation.lng);
      }

      // Charger l'itinéraire
      final route = await HotelService.fetchRoute(
        position.latitude,
        position.longitude,
        destinationCoordinates.latitude,
        destinationCoordinates.longitude,
      );

      setState(() {
        _routeCoordinates =
            route.map((coord) => LatLng(coord[0], coord[1])).toList();
      });
      _showSnackBar(
          'Itinéraire vers $_selectedDestination chargé avec succès !');
    } catch (error) {
      _showSnackBar('Erreur : $error');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
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
                      ...stationBus.lines.map((line) =>
                          Padding(
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


  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.7,
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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.7,
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


  void _updateMarkers() {
    List<Marker> markers = [];
    if (!_filterHotels5Star && !_filterHotels4Star && !_filterHotels3Star &&
        !_filterHotels2Star &&
        !_filterRestaurantsItalien && !_filterRestaurantsFastFood &&
        !_filterRestaurantsMarocain &&
        !_filterRestaurantsOriental && !_filterRestaurantsAsiatique &&
        !_filterBusLine101 && !_filterBusLine102 && !_filterBusLine104 &&
        !_filterBusLine106 && !_filterBusLine107 &&
        !_filterLine1 && !_filterLine2) {
      _hotels.forEach((hotel) {
        markers.add(Marker(
          point: LatLng(hotel.latitude, hotel.longitude),
          builder: (ctx) =>
              GestureDetector(
                onTap: () => _showHotelDetails(hotel),
                child: Icon(Icons.hotel, color: Colors.redAccent, size: 15),
              ),
        ));
      });

      _restaurants.forEach((restaurant) {
        markers.add(Marker(
          point: LatLng(restaurant.latitude, restaurant.longitude),
          builder: (ctx) =>
              GestureDetector(
                onTap: () => _showRestaurantDetails(restaurant),
                child: Icon(Icons.restaurant, color: Colors.purple, size: 15),
              ),
        ));
      });
      _stationsBus.forEach((station) {
        markers.add(Marker(
          point: LatLng(station.lat, station.lng),
          builder: (ctx) =>
              GestureDetector(
                onTap: () => _showBusStationDetails(station),
                child: Icon(
                    Icons.directions_bus, color: Colors.green, size: 15),
              ),
        ));
      });

      _stations.forEach((stationT) {
        markers.add(Marker(
          point: LatLng(stationT.lat, stationT.lng),
          builder: (ctx) =>
              GestureDetector(
                onTap: () => _showStationDetails(stationT),
                child: Icon(Icons.train, color: Colors.blue, size: 15),
              ),
        ));
      });
    }

    if (_filterHotels5Star || _filterHotels4Star || _filterHotels3Star ||
        _filterHotels2Star) {
      _hotels.forEach((hotel) {
        if ((_filterHotels5Star && hotel.etoiles == 5) ||
            (_filterHotels4Star && hotel.etoiles == 4) ||
            (_filterHotels3Star && hotel.etoiles == 3) ||
            (_filterHotels2Star && hotel.etoiles == 2)) {
          markers.add(Marker(
            point: LatLng(hotel.latitude, hotel.longitude),
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showHotelDetails(hotel),
                  child: Icon(Icons.hotel, color: Colors.redAccent, size: 35),
                ),
          ));
        }
      });
    }

    if (_filterRestaurantsItalien || _filterRestaurantsFastFood ||
        _filterRestaurantsMarocain ||
        _filterRestaurantsOriental || _filterRestaurantsAsiatique) {
      _restaurants.forEach((restaurant) {
        if ((_filterRestaurantsItalien && restaurant.categorie == 'Italien') ||
            (_filterRestaurantsFastFood &&
                restaurant.categorie == 'Fast Food') ||
            (_filterRestaurantsMarocain &&
                restaurant.categorie == 'Marocain') ||
            (_filterRestaurantsOriental &&
                restaurant.categorie == 'Oriental') ||
            (_filterRestaurantsAsiatique &&
                restaurant.categorie == 'Asiatique')) {
          markers.add(Marker(
            point: LatLng(restaurant.latitude, restaurant.longitude),
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showRestaurantDetails(restaurant),
                  child: Icon(Icons.restaurant, color: Colors.purple, size: 35),
                ),
          ));
        }
      });
    }

    if (_filterBusLine101 || _filterBusLine102 || _filterBusLine104 ||
        _filterBusLine106 || _filterBusLine107) {
      _stationsBus.forEach((station) {
        if ((_filterBusLine101 && station.lines.contains("L101")) ||
            (_filterBusLine102 && station.lines.contains("L102")) ||
            (_filterBusLine104 && station.lines.contains("L104")) ||
            (_filterBusLine106 && station.lines.contains("L106")) ||
            (_filterBusLine107 && station.lines.contains("L107"))) {
          markers.add(Marker(
            point: LatLng(station.lat, station.lng),
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showBusStationDetails(station),
                  child: Icon(Icons.directions_bus, color: Colors.greenAccent,
                      size: 35),
                ),
          ));
        }
      });
    }
    if (_filterLine1 || _filterLine2) {
      _stations.forEach((stationT) {
        if ((_filterLine1 && stationT.lines.contains("L1")) ||
            (_filterLine2 && stationT.lines.contains("L2"))) {
          markers.add(Marker(
            point: LatLng(stationT.lat, stationT.lng),
            builder: (ctx) =>
                GestureDetector(
                  onTap: () => _showStationDetails(stationT),
                  child: Icon(Icons.train, color: Colors.blueAccent, size: 35),
                ),
          ));
        }
      });
    }
    setState(() {
      _markers = markers;
    });
  }


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

      _filterLine1 = filters['line_1'] ?? false;
      _filterLine2 = filters['line_2'] ?? false;
    });

    _updateMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte des Hôtels'),
      ),
      drawer: CustomSidebar(
        onFilterChanged: _onFilterChanged,
        filterHotels5Star: _filterHotels5Star,
        filterHotels4Star: _filterHotels4Star,
        filterHotels3Star: _filterHotels3Star,
        filterHotels2Star: _filterHotels2Star,
        filterRestaurantsItalien: _filterRestaurantsItalien,
        filterRestaurantsFastFood: _filterRestaurantsFastFood,
        filterRestaurantsMarocain: _filterRestaurantsMarocain,
        filterRestaurantsAsiatique: _filterRestaurantsAsiatique,
        filterLine1: _filterLine1,
        filterLine2: _filterLine2,
        filterBusLine101: _filterBusLine101,
        filterBusLine102: _filterBusLine102,
        filterBusLine104: _filterBusLine104,
        filterBusLine106: _filterBusLine106,
      ),
      body: Column(
        children: [
          // Barre de recherche avec bouton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fond blanc pour la barre
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 201, 143, 211),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return _destinations.where((destination) =>
                              destination.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (String selection) {
                          setState(() {
                            _selectedDestination = selection;
                          });
                        },
                        fieldViewBuilder:
                            (context, controller, focusNode,
                            onEditingComplete) {
                          return TextField(
                            controller: controller,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              hintText: 'Rechercher une destination',
                              hintStyle: TextStyle(fontSize: 14),
                              border: InputBorder.none,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: fetchRouteToSelectedDestination,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Tracer Itinéraire'),
                ),
              ],
            ),
          ),

          // Espacement entre la barre de recherche et la carte
          SizedBox(height: 50),

          // Carte en bas
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
                if (_routeCoordinates.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routeCoordinates,
                        color: Colors.blue,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}