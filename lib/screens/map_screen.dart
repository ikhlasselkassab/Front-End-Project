import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
import '../models/stationBus.dart';
import '../services/Destination-service.dart';
import '../services/filters.dart';
import '../services/hotel-service.dart';
import '../services/markers.dart';
import '../services/restaurant-service.dart';
import '../services/stationBus-service.dart';
import '../services/stationTrame-service.dart';
import '../widgets/bus_station_dialog.dart';
import '../widgets/custom_sidebar.dart';
import '../widgets/hotel_dialog.dart';
import '../widgets/map_widget.dart';
import '../widgets/restaurant_dialog.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/station_dialog.dart';

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
  late LatLng _currentPosition;
  late MapController _mapController;
  List<Polyline> _polylines = [];
  Set<Polyline> polylines = {};










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
  bool _showStaticLine1 = false;












  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    loadHotels();
    loadRestaurants();
    loadBusStations();
    loadStations();
    loadDestinations();
    loadAirport();
    loadGares();
    loadStade();


  }










  Future<void> loadGares() async {
  try {
    // Coordonnées de la Gare Rabat Agdal
    final gareAgdalCoordinates = LatLng(34.00232205505089, -6.855607461943176);
    
    // Coordonnées de la Gare Rabat Ville
    final gareVilleCoordinates = LatLng(34.016568773487144, -6.8355616582435825);

    // Ajouter le marqueur pour la Gare Rabat Agdal
    setState(() {
      _markers.add(Marker(
        point: gareAgdalCoordinates,
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Afficher un message ou effectuer une action lorsque le marqueur est touché
            _showSnackBar('Gare Rabat Agdal');
          },
          child: Icon(Icons.train, color: Colors.orange, size: 20),
        ),
      ));

      // Ajouter le marqueur pour la Gare Rabat Ville
      _markers.add(Marker(
        point: gareVilleCoordinates,
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Afficher un message ou effectuer une action lorsque le marqueur est touché
            _showSnackBar('Gare Rabat Ville');
          },
          child: Icon(Icons.train, color: Colors.orange, size: 30),
        ),
      ));
    });
  } catch (error) {
    print('Erreur lors du chargement des gares: $error');
  }
}

  Future<void> loadAirport() async {
  try {
    // Coordonnées de l'Aéroport de Rabat-Salé
    final airportCoordinates = LatLng(34.05049670986896, -6.7495096);

    // Ajouter le marqueur pour l'aéroport
    setState(() {
      _markers.add(Marker(
        point: airportCoordinates,
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Afficher un message ou effectuer une action lorsque le marqueur est touché
            _showSnackBar('Aéroport de Rabat-Salé');
          },
          child: Icon(Icons.airplanemode_active, color: Colors.blue, size: 30),
        ),
      ));
    });
  } catch (error) {
    print('Erreur lors du chargement de l\'aéroport: $error');
  }
}




  Future<void> loadStade() async {
    try {
      // Coordonnées de l'Aéroport de Rabat-Salé
      final stadeCoordinates = LatLng(33.960055394978745, -6.88897151712504);

      // Ajouter le marqueur pour l'aéroport
      setState(() {
        _markers.add(Marker(
          point: stadeCoordinates,
          builder: (ctx) => GestureDetector(
            onTap: () {
              // Afficher un message ou effectuer une action lorsque le marqueur est touché
              _showSnackBar('Stade Prince Moulay Abdellah ');
            },
            child: Icon(Icons.stadium_sharp, color: Colors.pink, size: 30),
          ),
        ));
      });
    } catch (error) {
      print('Erreur lors du chargement du stade: $error');
    }
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

  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestaurantDialog(restaurant: restaurant);
      },
    );
  }

  void _showStationDetails(Station station) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StationDialog(station: station);
      },
    );
  }

  void _showBusStationDetails(StationBus stationBus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BusStationDialog(stationBus: stationBus);
      },
    );
  }

  void _showHotelDetails(Hotel hotel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HotelDialog(hotel: hotel);
      },
    );
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
      _destinations.addAll([
        'Gare Rabat Agdal',
        'Gare Rabat Ville',
        'Aéroport de Rabat-Salé',
        'Stade Prince Moulay Abdellah '
      ]);
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
    final isHotel = _hotels.any((hotel) => hotel.name == _selectedDestination);
    final isStation = _stations.any((station) => station.name == _selectedDestination);
    final isGare = _selectedDestination == 'Gare Rabat Agdal' || _selectedDestination == 'Gare Rabat Ville';
    final isAirport = _selectedDestination == 'Aéroport de Rabat-Salé';
    final isStade = _selectedDestination == 'Stade Prince Moulay Abdellah';


    if (!isHotel && !isStation && !isGare && !isAirport && !isStade) {
      _showSnackBar('Destination inconnue.');
      return;
    }

    // Récupérer la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print('Position actuelle : ${position.latitude}, ${position.longitude}');

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        point: _currentPosition,
        builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
      ));
    });

    // Déterminer les coordonnées de destination
    LatLng destinationCoordinates;

    if (isHotel) {
      final destinationHotel = _hotels.firstWhere((hotel) => hotel.name == _selectedDestination);
      destinationCoordinates = LatLng(destinationHotel.latitude, destinationHotel.longitude);
    } else if (isStation) {
      final destinationStation = _stations.firstWhere((station) => station.name == _selectedDestination);
      destinationCoordinates = LatLng(destinationStation.lat, destinationStation.lng);
    } else if (isGare) {
      destinationCoordinates = _selectedDestination == 'Gare Rabat Agdal'
          ? LatLng(34.00232205505089, -6.855607461943176)
          : LatLng(34.016568773487144, -6.8355616582435825);
    } else if (isAirport) {
      destinationCoordinates = LatLng(34.05049670986896, -6.7495096);
      print('Destination : ${destinationCoordinates.latitude}, ${destinationCoordinates.longitude}');

    }
    else if (isStade) {
      destinationCoordinates = _selectedDestination == 'Stade Prince Moulay Abdellah'
          ?LatLng(34.00232205505089, -6.855607461943176)
          :LatLng(33.960055394978745, -6.88897151712504);
      print('Destination : ${destinationCoordinates.latitude}, ${destinationCoordinates.longitude}');
      }
    else {
      throw Exception('Type de destination inconnu.');
    }

    print('Destination : ${destinationCoordinates.latitude}, ${destinationCoordinates.longitude}');

    // Rechercher l'itinéraire
    final route = await HotelService.fetchRoute(
      position.latitude,
      position.longitude,
      destinationCoordinates.latitude,
      destinationCoordinates.longitude,
    );

    if (route.isEmpty) {
      _showSnackBar('Aucune route disponible vers $_selectedDestination.');
      return;
    }

    print('Itinéraire récupéré : ${route.length} points.');

    setState(() {
      _routeCoordinates.clear();
      _routeCoordinates = route.map((coord) => LatLng(coord[0], coord[1])).toList();
    });

    _mapController.move(_currentPosition, 14);

    _showSnackBar('Itinéraire vers $_selectedDestination chargé avec succès !');
  } catch (error) {
    print('Erreur : $error');
    _showSnackBar('Erreur : $error');
  }
}



  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)));
  }



  final filters = Filters();
  final markerService = MarkerService();

  void _onFilterChanged(Map<String, bool> newFilters) {
    setState(() {
      filters.updateFilters(newFilters);
      _markers = markerService.updateMarkers(
        hotels: _hotels,
        restaurants: _restaurants,
        busStations: _stationsBus,
        trainStations: _stations,
        filters: filters,
        onHotelTap: _showHotelDetails,
        onRestaurantTap: _showRestaurantDetails,
        onBusStationTap: _showBusStationDetails,
        onTrainStationTap: _showStationDetails,
      );


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebar(
        onFilterChanged: _onFilterChanged,
        filters: filters.activeFilters,
      ),
      body: Stack(
        children: [
          // La carte
          MapWidget(
            mapController: _mapController,
            markers: _markers,
            routeCoordinates: _routeCoordinates,
            polylines: _polylines,
          ),

          // Icône du menu en haut à gauche
          Positioned(
            top: 20.0,
            left: 10.0,
            child: SafeArea(
              child: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu, color: Colors.black, size: 30),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            ),
          ),

          // Barre de recherche en haut
          Positioned(
            top: 80.0,
            left: 0.0,
            right: 0.0,
            child: SafeArea(
              child: SearchBarWidget(
                destinations: _destinations,
                onDestinationSelected: (selection) {
                  setState(() {
                    _selectedDestination = selection;
                  });
                },
                onSearchPressed: fetchRouteToSelectedDestination,
              ),
            ),
          ),
        ],
      ),
    );
  }
}