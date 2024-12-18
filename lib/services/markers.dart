import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ikhl/models/stationBus.dart';
import 'package:latlong2/latlong.dart';
import '../models/hotel.dart';
import '../models/restaurant.dart';
import '../models/station.dart';
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

    if (!_anyFilterApplied(filters)) {
      _addDefaultMarkers(
        markers: markers,
        hotels: hotels,
        restaurants: restaurants,
        busStations: busStations,
        trainStations: trainStations,
        onHotelTap: onHotelTap,
        onRestaurantTap: onRestaurantTap,
        onBusStationTap: onBusStationTap,
        onTrainStationTap: onTrainStationTap,
      );
    } else {
      _addFilteredMarkers(
        markers: markers,
        filters: filters,
        hotels: hotels,
        restaurants: restaurants,
        busStations: busStations,
        trainStations: trainStations,
        onHotelTap: onHotelTap,
        onRestaurantTap: onRestaurantTap,
        onBusStationTap: onBusStationTap,
        onTrainStationTap: onTrainStationTap,
      );
    }

    return markers;
  }

  bool _anyFilterApplied(Filters filters) {
    return filters.filterHotels5Star ||
        filters.filterHotels4Star ||
        filters.filterHotels3Star ||
        filters.filterHotels2Star ||
        filters.filterRestaurantsItalien ||
        filters.filterRestaurantsFastFood ||
        filters.filterRestaurantsMarocain ||
        filters.filterRestaurantsOriental ||
        filters.filterRestaurantsAsiatique ||
        filters.filterBusLine101 ||
        filters.filterBusLine102 ||
        filters.filterBusLine104 ||
        filters.filterBusLine106 ||
        filters.filterBusLine107 ||
        filters.filterLine1 ||
        filters.filterLine2;
  }

  void _addDefaultMarkers({
    required List<Marker> markers,
    required List<Hotel> hotels,
    required List<Restaurant> restaurants,
    required List<StationBus> busStations,
    required List<Station> trainStations,
    required Function(Hotel) onHotelTap,
    required Function(Restaurant) onRestaurantTap,
    required Function(StationBus) onBusStationTap,
    required Function(Station) onTrainStationTap,
  }) {
    hotels.forEach((hotel) {
      markers.add(_createMarker(
        latitude: hotel.latitude,
        longitude: hotel.longitude,
        icon: Icons.hotel,
        color: Colors.redAccent,
        size: 15,
        onTap: () => onHotelTap(hotel),
      ));
    });

    restaurants.forEach((restaurant) {
      markers.add(_createMarker(
        latitude: restaurant.latitude,
        longitude: restaurant.longitude,
        icon: Icons.restaurant,
        color: Colors.purple,
        size: 15,
        onTap: () => onRestaurantTap(restaurant),
      ));
    });

    busStations.forEach((station) {
      markers.add(_createMarker(
        latitude: station.lat,
        longitude: station.lng,
        icon: Icons.directions_bus,
        color: Colors.green,
        size: 15,
        onTap: () => onBusStationTap(station),
      ));
    });

    trainStations.forEach((station) {
      markers.add(_createMarker(
        latitude: station.lat,
        longitude: station.lng,
        icon: Icons.train,
        color: Colors.blue,
        size: 15,
        onTap: () => onTrainStationTap(station),
      ));
    });
  }

  void _addFilteredMarkers({
    required List<Marker> markers,
    required Filters filters,
    required List<Hotel> hotels,
    required List<Restaurant> restaurants,
    required List<StationBus> busStations,
    required List<Station> trainStations,
    required Function(Hotel) onHotelTap,
    required Function(Restaurant) onRestaurantTap,
    required Function(StationBus) onBusStationTap,
    required Function(Station) onTrainStationTap,
  }) {
    hotels.forEach((hotel) {
      if ((filters.filterHotels5Star && hotel.etoiles == 5) ||
          (filters.filterHotels4Star && hotel.etoiles == 4) ||
          (filters.filterHotels3Star && hotel.etoiles == 3) ||
          (filters.filterHotels2Star && hotel.etoiles == 2)) {
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

    restaurants.forEach((restaurant) {
      if ((filters.filterRestaurantsItalien &&
          restaurant.categorie == 'Italien') ||
          (filters.filterRestaurantsFastFood &&
              restaurant.categorie == 'Fast Food') ||
          (filters.filterRestaurantsMarocain &&
              restaurant.categorie == 'Marocain') ||
          (filters.filterRestaurantsOriental &&
              restaurant.categorie == "oriental") ||
          (filters.filterRestaurantsAsiatique &&
              restaurant.categorie == 'Asiatique')) {
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

    busStations.forEach((station) {
      if ((filters.filterBusLine101 && station.lines.contains("L101")) ||
          (filters.filterBusLine102 && station.lines.contains("L102")) ||
          (filters.filterBusLine104 && station.lines.contains("L104")) ||
          (filters.filterBusLine106 && station.lines.contains("L106")) ||
          (filters.filterBusLine107 && station.lines.contains("L107"))) {
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

    trainStations.forEach((station) {
      if ((filters.filterLine1 && station.lines.contains("L1")) ||
          (filters.filterLine2 && station.lines.contains("L2"))) {
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
  }

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
