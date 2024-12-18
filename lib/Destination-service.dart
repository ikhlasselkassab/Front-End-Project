import 'stationTrame-service.dart';
import 'restaurant-service.dart';


import 'hotel-service.dart';

class DestinationService {
  static Future<List<String>> fetchAllDestinations() async {
    final hotels = await HotelService.fetchHotels();
    final stations = await StationTrameService().fetchStations();
    final restaurants = await RestaurantService.fetchRestaurants();

    return [
      ...hotels.map((hotel) => hotel.name),
      ...stations.map((station) => station.name),
      ...restaurants.map((restaurant) => restaurant.nom),
    ];
  }
}
