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
  void _showRestaurantDetails(Restaurant restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RestaurantDialog(restaurant: restaurant);
      },
    );
  }
  void _showStationDetails(Station station){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StationDialog(station : station);
      },
    );

  }
  void _showBusStationDetails(StationBus stationBus){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BusStationDialog(stationBus : stationBus);
      },
    );

  }
  void _showHotelDetails(Hotel hotel){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HotelDialog(hotel : hotel);
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
      final isHotel = _hotels.any((hotel) =>
      hotel.name == _selectedDestination);
      final isStation = _stations.any((station) =>
      station.name == _selectedDestination);

      if (!isHotel && !isStation) {
        _showSnackBar('Destination inconnue.');
        return;
      }

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
      appBar: AppBar(
        title: const Text('Carte des Hôtels'),
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
        filterRestaurantsOriental: _filterRestaurantsOriental,
        filterRestaurantsAsiatique: _filterRestaurantsAsiatique,
        filterLine1: _filterLine1,
        filterLine2: _filterLine2,
        filterBusLine101: _filterBusLine101,
        filterBusLine102: _filterBusLine102,
        filterBusLine104: _filterBusLine104,
        filterBusLine106: _filterBusLine106,
        filterBusLine107: _filterBusLine107,

      ),
      body: Column(
        children: [
          SearchBarWidget(
            destinations: _destinations,
            onDestinationSelected: (selection) {
              setState(() {
                _selectedDestination = selection;
              });
            },
            onSearchPressed: fetchRouteToSelectedDestination,
          ),
          const SizedBox(height: 50),
          Expanded(
            child: MapWidget(
              markers: _markers,
              routeCoordinates: _routeCoordinates,
            ),
          ),
        ],
      ),
    );
  }
}