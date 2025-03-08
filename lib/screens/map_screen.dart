import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
import '../widgets/Destination_detail_card.dart';
import '../widgets/bus_station_dialog.dart';
import '../widgets/custom_sidebar.dart';
import '../widgets/hotel_dialog.dart';
import '../widgets/map_widget.dart';
import '../widgets/restaurant_dialog.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/station_dialog.dart';
import '../widgets/vibre.dart';

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
      final gareAgdalCoordinates = LatLng(34.00232205505089, -6.855607461943176);
      final gareVilleCoordinates = LatLng(34.016568773487144, -6.8355616582435825);

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
    } catch (error) {
      print('Erreur lors du chargement des gares: $error');
    }
  }

  Future<void> loadAirport() async {
    try {
      final airportCoordinates = LatLng(34.05049670986896, -6.7495096);

      setState(() {
        _markers.add(Marker(
          point: airportCoordinates,
          builder: (ctx) => GestureDetector(
            onTap: () => _showSnackBar('Aéroport de Rabat-Salé'),
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
      final stadeCoordinates = LatLng(33.960055394978745, -6.88897151712504);

      setState(() {
        _markers.add(Marker(
          point: stadeCoordinates,
          builder: (ctx) => GestureDetector(
            onTap: () => _showSnackBar('Stade Prince Moulay Abdellah'),
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

  Future<void> loadStations() async {
    try {
      final stations = await StationTrameService.fetchStations();
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
      setState(() {
        _destinations = destinations;
        _destinations.addAll([
          'Gare Rabat Agdal',
          'Gare Rabat Ville',
          'Aéroport de Rabat-Salé',
          'Stade Prince Moulay Abdellah'
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
      // Récupérer la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Position actuelle : ${position.latitude}, ${position.longitude}');

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);

        // Ajouter un marqueur pour la position actuelle
        _markers.add(
          Marker(
            point: _currentPosition,
            builder: (ctx) => Stack(
              alignment: Alignment.center,
              children: [
                VibratingMarker(), // Cercle vibrant
                const CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.deepPurple, // Cercle central
                ),
              ],
            ),
          ),
        );
      });

      // Déterminer les coordonnées de destination
      LatLng destinationCoordinates;

      if (_selectedDestination is Hotel) {
        destinationCoordinates = LatLng(_selectedDestination.latitude, _selectedDestination.longitude);
      } else if (_selectedDestination is Restaurant) {
        destinationCoordinates = LatLng(_selectedDestination.latitude, _selectedDestination.longitude);
      } else if (_selectedDestination is Station) {
        destinationCoordinates = LatLng(_selectedDestination.lat, _selectedDestination.lng);
      } else if (_selectedDestination is StationBus) {
        destinationCoordinates = LatLng(_selectedDestination.lat, _selectedDestination.lng);
      } else if (_selectedDestination == 'Gare Rabat Agdal') {
        destinationCoordinates = LatLng(34.00232205505089, -6.855607461943176);
      } else if (_selectedDestination == 'Gare Rabat Ville') {
        destinationCoordinates = LatLng(34.016568773487144, -6.8355616582435825);
      } else if (_selectedDestination == 'Aéroport de Rabat-Salé') {
        destinationCoordinates = LatLng(34.05049670986896, -6.7495096);
      } else if (_selectedDestination == 'Stade Prince Moulay Abdellah') {
        destinationCoordinates = LatLng(33.960055394978745, -6.88897151712504);
      } else {
        throw Exception('Type de destination inconnu.');
      }

      print('Destination : ${destinationCoordinates.latitude}, ${destinationCoordinates.longitude}');

      // Rechercher l'itinéraire
      List<List<double>> route;
      if (_selectedDestination is Hotel || _selectedDestination is Restaurant) {
        route = await RestaurantService.fetchRoute(
          position.latitude,
          position.longitude,
          destinationCoordinates.latitude,
          destinationCoordinates.longitude,
        );
      } else {
        route = await HotelService.fetchRoute(
          position.latitude,
          position.longitude,
          destinationCoordinates.latitude,
          destinationCoordinates.longitude,
        );
      }

      if (route.isEmpty) {
        _showSnackBar('Aucune route disponible vers $_selectedDestination.');
        return;
      }

      print('Itinéraire récupéré : ${route.length} points.');

      setState(() {
        _routeCoordinates.clear();
        _routeCoordinates = route.map((coord) => LatLng(coord[0], coord[1])).toList();
        _mapController.move(destinationCoordinates, 18);

        // Ajouter un marqueur pour la destination
        _markers.add(
          Marker(
            point: destinationCoordinates,
            builder: (ctx) => const Icon(Icons.place, color: Colors.redAccent, size: 50),
          ),
        );
      });

      _showSnackBar('Itinéraire vers $_selectedDestination chargé avec succès !');
    } catch (error) {
      print('Erreur : $error');
      _showSnackBar('Erreur : $error');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                if (_selectedDestination != null)
                  Positioned(
                    bottom: 100.0, // Position de l'icône
                    right: 20.0,
                    child: GestureDetector(
                      onTap: fetchRouteToSelectedDestination, // Afficher l'itinéraire
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
                        child: Icon(Icons.directions, color: Colors.blue, size: 40),
                      ),
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
      setState(() {
        _selectedDestination = hotel;
      });
      _centerMapOnDestination(hotel);
    } else if (isRestaurant) {
      final restaurant = _restaurants.firstWhere((restaurant) => restaurant.nom == selection);
      setState(() {
        _selectedDestination = restaurant;
      });
      _centerMapOnDestination(restaurant);
    } else if (isStation) {
      final station = _stations.firstWhere((station) => station.name == selection);
      setState(() {
        _selectedDestination = station;
      });
      _centerMapOnDestination(station);
    } else if (isStationBus) {
      final stationBus = _stationsBus.firstWhere((stationBus) => stationBus.name == selection);
      setState(() {
        _selectedDestination = stationBus;
      });
      _centerMapOnDestination(stationBus);
    } else if (isGare || isAirport || isStade) {
      setState(() {
        _selectedDestination = selection;
      });
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

  void _onCloseDetails() {
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