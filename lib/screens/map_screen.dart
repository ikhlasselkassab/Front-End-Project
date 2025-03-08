import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/hotel_dialog.dart';

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
import '../widgets/Destination_detail_card.dart';
import '../widgets/bus_station_dialog.dart';
import '../widgets/custom_sidebar.dart';
import '../widgets/map_widget.dart';
import '../widgets/restaurant_dialog.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/station_dialog.dart';
import '../widgets/vibre.dart';
import '../widgets/route_selection_card.dart';

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
  dynamic _selectedDestination;
  LatLng? _selectedDestinationCoordinates;
  bool _showRouteSelectionCard = false;
  String? _selectedStartPoint;
  String? _selectedEndPoint;

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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadGares() async {
    try {
      final gareAgdalCoordinates = LatLng(34.00232205505089, -6.855607461943176);
      final gareVilleCoordinates = LatLng(34.016568773487144, -6.8355616582435825);

      if (mounted) {
        setState(() {
          _markers.add(Marker(
            point: gareAgdalCoordinates,
            builder: (ctx) => GestureDetector(
              onTap: () => _showSnackBar('Gare Rabat Agdal'),
              child: Icon(Icons.train, color: Colors.orange, size: 20),
            ),
          ));

          _markers.add(Marker(
            point: gareVilleCoordinates,
            builder: (ctx) => GestureDetector(
              onTap: () => _showSnackBar('Gare Rabat Ville'),
              child: Icon(Icons.train, color: Colors.orange, size: 30),
            ),
          ));
        });
      }
    } catch (error) {
      print('Erreur lors du chargement des gares: $error');
    }
  }

  Future<void> loadAirport() async {
    try {
      final airportCoordinates = LatLng(34.05049670986896, -6.7495096);

      if (mounted) {
        setState(() {
          _markers.add(Marker(
            point: airportCoordinates,
            builder: (ctx) => GestureDetector(
              onTap: () => _showSnackBar('Aéroport de Rabat-Salé'),
              child: Icon(Icons.airplanemode_active, color: Colors.blue, size: 30),
            ),
          ));
        });
      }
    } catch (error) {
      print('Erreur lors du chargement de l\'aéroport: $error');
    }
  }

  Future<void> loadStade() async {
    try {
      final stadeCoordinates = LatLng(33.960055394978745, -6.88897151712504);

      if (mounted) {
        setState(() {
          _markers.add(Marker(
            point: stadeCoordinates,
            builder: (ctx) => GestureDetector(
              onTap: () => _showSnackBar('Stade Prince Moulay Abdellah'),
              child: Icon(Icons.stadium_sharp, color: Colors.pink, size: 30),
            ),
          ));
        });
      }
    } catch (error) {
      print('Erreur lors du chargement du stade: $error');
    }
  }

  Future<void> loadHotels() async {
    try {
      final hotels = await HotelService.fetchHotels();
      if (mounted) {
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
      }
    } catch (error) {
      print('Error loading hotels: $error');
    }
  }

  Future<void> loadRestaurants() async {
    try {
      final restaurants = await RestaurantService.fetchRestaurants();
      if (mounted) {
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
      }
    } catch (error) {
      print('Error loading restaurants: $error');
    }
  }

  Future<void> loadStations() async {
    try {
      final stations = await StationTrameService.fetchStations();
      if (mounted) {
        setState(() {
          _stations = stations;
          _markers.addAll(_stations.map((station) {
            return Marker(
              point: LatLng(station.lat, station.lng),
              builder: (ctx) => GestureDetector(
                onTap: () => _showStationDetails(station),
                child: Icon(Icons.train, color: Colors.blueAccent, size: 15),
              ),
            );
          }).toList());
        });
      }
    } catch (error) {
      print('Error loading stations: $error');
    }
  }

  Future<void> loadBusStations() async {
    try {
      final stationsBus = await StationBusService.fetchBusStations();
      if (mounted) {
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
      }
    } catch (error) {
      print('Error loading bus stations: $error');
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

  Future<void> loadDestinations() async {
    try {
      final destinations = await DestinationService.fetchAllDestinations();
      if (mounted) {
        setState(() {
          _destinations = destinations;
          _destinations.addAll([
            'Gare Rabat Agdal',
            'Gare Rabat Ville',
            'Aéroport de Rabat-Salé',
            'Stade Prince Moulay Abdellah'
          ]);
        });
      }
    } catch (e) {
      _showSnackBar('Erreur lors du chargement des destinations.');
    }
  }

  void _showRouteSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: RouteSelectionCard(
            destinations: _destinations,
            onStartPointSelected: _onStartPointSelected,
            onEndPointSelected: _onEndPointSelected,
            onClose: () {
              Navigator.pop(context); // Fermer le Dialog
            },
            onFetchRoute: _fetchRoute,
          ),
        );
      },
    );
  }

  void _hideRouteSelection() {
    if (mounted) {
      setState(() {
        _showRouteSelectionCard = false;
      });
    }
  }

  void _onStartPointSelected(String? startPoint) {
    if (mounted) {
      setState(() {
        _selectedStartPoint = startPoint;
      });
    }
  }

  void _onEndPointSelected(String? endPoint) {
    if (mounted) {
      setState(() {
        _selectedEndPoint = endPoint;
      });
    }
  }

  Future<void> _fetchRoute() async {
    if (_selectedStartPoint == null || _selectedEndPoint == null) {
      _showSnackBar('Veuillez sélectionner un point de départ et un point d\'arrivée.');
      return;
    }

    try {
      LatLng startCoordinates;
      if (_selectedStartPoint == 'Position actuelle') {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        startCoordinates = LatLng(position.latitude, position.longitude);
      } else {
        startCoordinates = _getCoordinatesFromDestination(_selectedStartPoint!);
        print('Start Coordinates: $startCoordinates');
      }

      LatLng endCoordinates = _getCoordinatesFromDestination(_selectedEndPoint!);
      print('End Coordinates: $endCoordinates');

      List<List<double>> route = await HotelService.fetchRoute(
        startCoordinates.latitude,
        startCoordinates.longitude,
        endCoordinates.latitude,
        endCoordinates.longitude,
      );

      if (route.isEmpty) {
        _showSnackBar('Aucune route disponible.');
        return;
      }

      if (mounted) {
        setState(() {
          _routeCoordinates = route.map((coord) => LatLng(coord[0], coord[1])).toList();
          _mapController.move(endCoordinates, 15);
        });
      }

      _showSnackBar('Itinéraire chargé avec succès !');
    } catch (error) {
      print('Erreur : $error');
      _showSnackBar('Erreur : $error');
    }
  }

  LatLng _getCoordinatesFromDestination(dynamic destination) {
    if (destination is String) {
      // Gestion des destinations sous forme de chaînes de caractères
      switch (destination) {
        case 'Gare Rabat Agdal':
          return LatLng(34.00232205505089, -6.855607461943176);
        case 'Gare Rabat Ville':
          return LatLng(34.016568773487144, -6.8355616582435825);
        case 'Aéroport de Rabat-Salé':
          return LatLng(34.05049670986896, -6.7495096);
        case 'Stade Prince Moulay Abdellah':
          return LatLng(33.960055394978745, -6.88897151712504);
        default:
        // Si la destination est un nom d'hôtel, restaurant, station, etc.
          return _getCoordinatesFromName(destination);
      }
    } else if (destination is Hotel) {
      // Gestion des destinations de type Hotel
      return LatLng(destination.latitude, destination.longitude);
    } else if (destination is Restaurant) {
      // Gestion des destinations de type Restaurant
      return LatLng(destination.latitude, destination.longitude);
    } else if (destination is Station) {
      // Gestion des destinations de type Station
      return LatLng(destination.lat, destination.lng);
    } else if (destination is StationBus) {
      // Gestion des destinations de type StationBus
      return LatLng(destination.lat, destination.lng);
    } else {
      throw Exception('Type de destination inconnu : $destination');
    }
  }

  LatLng _getCoordinatesFromName(String destinationName) {
    // Vérifier si la destination est un hôtel
    final isHotel = _hotels.any((hotel) => hotel.name == destinationName);
    if (isHotel) {
      final hotel = _hotels.firstWhere((hotel) => hotel.name == destinationName);
      return LatLng(hotel.latitude, hotel.longitude);
    }

    // Vérifier si la destination est un restaurant
    final isRestaurant = _restaurants.any((restaurant) => restaurant.nom == destinationName);
    if (isRestaurant) {
      final restaurant = _restaurants.firstWhere((restaurant) => restaurant.nom == destinationName);
      return LatLng(restaurant.latitude, restaurant.longitude);
    }

    // Vérifier si la destination est une station de train
    final isStation = _stations.any((station) => station.name == destinationName);
    if (isStation) {
      final station = _stations.firstWhere((station) => station.name == destinationName);
      return LatLng(station.lat, station.lng);
    }

    // Vérifier si la destination est une station de bus
    final isStationBus = _stationsBus.any((stationBus) => stationBus.name == destinationName);
    if (isStationBus) {
      final stationBus = _stationsBus.firstWhere((stationBus) => stationBus.name == destinationName);
      return LatLng(stationBus.lat, stationBus.lng);
    }

    // Si la destination n'est pas trouvée, lever une exception
    throw Exception('Destination inconnue : $destinationName');
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomSidebar(
        onFilterChanged: _onFilterChanged,
        filters: filters.activeFilters,
      ),
      body: Row(
        children: [
          // Partie gauche : Carte
          Expanded(
            flex: 2, // 2/3 de l'écran pour la carte
            child: Stack(
              children: [
                MapWidget(
                  mapController: _mapController,
                  markers: _markers,
                  routeCoordinates: _routeCoordinates,
                  polylines: _polylines,
                ),
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
                Positioned(
                  top: 80.0,
                  left: 0.0,
                  right: 0.0,
                  child: SafeArea(
                    child: SearchBarWidget(
                      destinations: _destinations,
                      onDestinationSelected: (selection) {
                        _onDestinationSelected(selection);
                      },
                      onSearchPressed: () {
                        // Ne rien faire ici, car l'itinéraire est tracé lors de la sélection
                      },
                    ),
                  ),
                ),

                // Icône d'itinéraire
                Positioned(
                  bottom: 100.0, // Position de l'icône
                  right: 20.0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.directions, color: Colors.blue, size: 40),
                      onPressed: _showRouteSelection, // Afficher la carte de sélection de l'itinéraire
                    ),
                  ),
                ),

                // Carte de sélection de l'itinéraire
                if (_showRouteSelectionCard)
                  Positioned(
                    bottom: 160.0,
                    right: 20.0,
                    child: RouteSelectionCard(
                      destinations: _destinations,
                      onStartPointSelected: _onStartPointSelected,
                      onEndPointSelected: _onEndPointSelected,
                      onClose: _hideRouteSelection,
                      onFetchRoute: _fetchRoute,
                    ),
                  ),
              ],
            ),
          ),

          // Partie droite : Détails de la destination
          if (_selectedDestination != null)
            Expanded(
              flex: 1, // 1/3 de l'écran pour les détails
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: DestinationDetailsCard(
                  destination: _selectedDestination!,
                  onClose: _onCloseDetails,
                ),
              ),
            ),
        ],
      ),
    );
  }

  final filters = Filters();
  final markerService = MarkerService();

  void _onFilterChanged(Map<String, bool> newFilters) {
    if (mounted) {
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
  }

  void _onDestinationSelected(dynamic selection) {
    print('Destination sélectionnée : $selection');

    final isHotel = _hotels.any((hotel) => hotel.name == selection);
    final isRestaurant = _restaurants.any((restaurant) => restaurant.nom == selection);
    final isStation = _stations.any((station) => station.name == selection);
    final isStationBus = _stationsBus.any((stationBus) => stationBus.name == selection);
    final isGare = selection == 'Gare Rabat Agdal' || selection == 'Gare Rabat Ville';
    final isAirport = selection == 'Aéroport de Rabat-Salé';
    final isStade = selection == 'Stade Prince Moulay Abdellah';

    if (isHotel) {
      final hotel = _hotels.firstWhere((hotel) => hotel.name == selection);
      if (mounted) {
        setState(() {
          _selectedDestination = hotel;
        });
      }
      _centerMapOnDestination(hotel);
    } else if (isRestaurant) {
      final restaurant = _restaurants.firstWhere((restaurant) => restaurant.nom == selection);
      if (mounted) {
        setState(() {
          _selectedDestination = restaurant;
        });
      }
      _centerMapOnDestination(restaurant);
    } else if (isStation) {
      final station = _stations.firstWhere((station) => station.name == selection);
      if (mounted) {
        setState(() {
          _selectedDestination = station;
        });
      }
      _centerMapOnDestination(station);
    } else if (isStationBus) {
      final stationBus = _stationsBus.firstWhere((stationBus) => stationBus.name == selection);
      if (mounted) {
        setState(() {
          _selectedDestination = stationBus;
        });
      }
      _centerMapOnDestination(stationBus);
    } else if (isGare || isAirport || isStade) {
      if (mounted) {
        setState(() {
          _selectedDestination = selection;
        });
      }
      _centerMapOnDestination(selection);
    } else {
      _showSnackBar('Destination introuvable.');
    }
  }

  void _centerMapOnDestination(dynamic destination) {
    LatLng destinationCoordinates;

    if (destination is Hotel) {
      destinationCoordinates = LatLng(destination.latitude, destination.longitude);
    } else if (destination is Restaurant) {
      destinationCoordinates = LatLng(destination.latitude, destination.longitude);
    } else if (destination is Station) {
      destinationCoordinates = LatLng(destination.lat, destination.lng);
    } else if (destination is StationBus) {
      destinationCoordinates = LatLng(destination.lat, destination.lng);
    } else if (destination == 'Gare Rabat Agdal') {
      destinationCoordinates = LatLng(34.00232205505089, -6.855607461943176);
    } else if (destination == 'Gare Rabat Ville') {
      destinationCoordinates = LatLng(34.016568773487144, -6.8355616582435825);
    } else if (destination == 'Aéroport de Rabat-Salé') {
      destinationCoordinates = LatLng(34.05049670986896, -6.7495096);
    } else if (destination == 'Stade Prince Moulay Abdellah') {
      destinationCoordinates = LatLng(33.960055394978745, -6.88897151712504);
    } else {
      throw Exception('Type de destination inconnu.');
    }

    // Centrer la carte sur la destination
    _mapController.move(destinationCoordinates, 15);

    // Ajouter un marqueur pour la destination
    if (mounted) {
      setState(() {
        _selectedDestinationCoordinates = destinationCoordinates; // Mettre à jour les coordonnées
        _markers.add(
          Marker(
            point: destinationCoordinates,
            builder: (ctx) => Icon(Icons.place, color: Colors.redAccent, size: 50),
          ),
        );
      });
    }
  }

  void _onCloseDetails() {
    if (mounted) {
      setState(() {
        // 1. Supprimer le marqueur de la destination sélectionnée
        if (_selectedDestinationCoordinates != null) {
          _markers.removeWhere((marker) =>
          marker.point.latitude == _selectedDestinationCoordinates!.latitude &&
              marker.point.longitude == _selectedDestinationCoordinates!.longitude
          );
        }

        // 2. Réinitialiser la destination sélectionnée
        _selectedDestination = null;

        // 3. Réinitialiser les coordonnées de la destination sélectionnée
        _selectedDestinationCoordinates = null;
      });
    }
  }
}