import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikhl/models/stationBus.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
import 'filters.dart';



import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
import '../models/stationBus.dart';
import 'filters.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
import '../models/stationBus.dart';
import 'filters.dart';

class MarkerService {
  List<Marker> updateMarkers({
    required List<Hotel> hotels,
    required List<Restaurant> restaurants,
    required List<StationBus> busStations,
    required List<Station> trainStations,
    required Filters filters,
    required Function(Hotel) onHotelTap,
    required Function(Restaurant) onRestaurantTap,
    required Function(StationBus) onBusStationTap,
    required Function(Station) onTrainStationTap,
  }) {
    List<Marker> markers = [];

    // Add filtered hotels
    hotels.forEach((hotel) {
      if (_matchesHotelFilter(hotel, filters)) {
        markers.add(_createMarker(
          latitude: hotel.latitude,
          longitude: hotel.longitude,
          icon: Icons.hotel,
          color: Colors.redAccent,
          size: 35,
          onTap: () => onHotelTap(hotel),
        ));
      }
    });

    // Add filtered restaurants
    restaurants.forEach((restaurant) {
      if (_matchesRestaurantFilter(restaurant, filters)) {
        markers.add(_createMarker(
          latitude: restaurant.latitude,
          longitude: restaurant.longitude,
          icon: Icons.restaurant,
          color: Colors.purple,
          size: 35,
          onTap: () => onRestaurantTap(restaurant),
        ));
      }
    });

    // Add filtered bus stations
    busStations.forEach((station) {
      if (_matchesBusStationFilter(station, filters)) {
        markers.add(_createMarker(
          latitude: station.lat,
          longitude: station.lng,
          icon: Icons.directions_bus,
          color: Colors.greenAccent,
          size: 35,
          onTap: () => onBusStationTap(station),
        ));
      }
    });

    // Add filtered train stations
    trainStations.forEach((station) {
      if (_matchesTrainStationFilter(station, filters)) {
        markers.add(_createMarker(
          latitude: station.lat,
          longitude: station.lng,
          icon: Icons.train,
          color: Colors.blueAccent,
          size: 35,
          onTap: () => onTrainStationTap(station),
        ));
      }
    });

    return markers;
  }

  // Helper methods to check filters
  bool _matchesHotelFilter(Hotel hotel, Filters filters) {
    return (filters.activeFilters['hotel_5_star'] == true && hotel.etoiles == 5) ||
        (filters.activeFilters['hotel_4_star'] == true && hotel.etoiles == 4) ||
        (filters.activeFilters['hotel_3_star'] == true && hotel.etoiles == 3) ||
        (filters.activeFilters['hotel_2_star'] == true && hotel.etoiles == 2);
  }

  bool _matchesRestaurantFilter(Restaurant restaurant, Filters filters) {
    return (filters.activeFilters['restaurant_italien'] == true &&
        restaurant.categorie.toLowerCase() == 'italien') ||
        (filters.activeFilters['restaurant_fastfood'] == true &&
            restaurant.categorie.toLowerCase() == 'fast food') ||
        (filters.activeFilters['restaurant_marocain'] == true &&
            restaurant.categorie.toLowerCase() == 'marocain') ||
        (filters.activeFilters['restaurant_oriental'] == true &&
            restaurant.categorie.toLowerCase() == 'oriental') ||
        (filters.activeFilters['restaurant_asiatique'] == true &&
            restaurant.categorie.toLowerCase() == 'asiatique');
  }

  bool _matchesBusStationFilter(StationBus station, Filters filters) {
    return (filters.activeFilters['bus_line_101'] == true &&
        station.lines.contains("L101")) ||
        (filters.activeFilters['bus_line_102'] == true &&
            station.lines.contains("L102")) ||
        (filters.activeFilters['bus_line_104'] == true &&
            station.lines.contains("L104")) ||
        (filters.activeFilters['bus_line_106'] == true &&
            station.lines.contains("L106")) ||
        (filters.activeFilters['bus_line_107'] == true &&
            station.lines.contains("L107"));
  }

  bool _matchesTrainStationFilter(Station station, Filters filters) {
    return (filters.activeFilters['line_1'] == true &&
        station.lines.contains("L1")) ||
        (filters.activeFilters['line_2'] == true &&
            station.lines.contains("L2"));
  }

  // Marker creation helper
  Marker _createMarker({
    required double latitude,
    required double longitude,
    required IconData icon,
    required Color color,
    required double size,
    required VoidCallback onTap,
  }) {
    return Marker(
      point: LatLng(latitude, longitude),
      builder: (ctx) => GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

