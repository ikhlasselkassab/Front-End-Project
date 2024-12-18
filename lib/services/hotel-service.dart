import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/hotel.dart';



class HotelService {
  static final String baseUrl = 'http://localhost:8081/api';

  // Récupérer la liste des hôtels
  static Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hotels'),
        headers: {'Accept': 'application/json; charset=UTF-8'}, // Assurer UTF-8
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Hotel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load hotels: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des hôtels: $e');
      throw Exception('Impossible de récupérer les hôtels.');
    }
  }

  // Récupérer l'itinéraire entre deux points
  static Future<List<List<double>>> fetchRoute(
      double startLat, double startLng, double endLat, double endLng) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/route?startLat=$startLat&startLng=$startLng&endLat=$endLat&endLng=$endLng'),
        headers: {'Accept': 'application/json; charset=UTF-8'}, // UTF-8 ici aussi
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(utf8.decode(response.bodyBytes));
        List<List<double>> coordinates = [];
        for (var coord in json['features'][0]['geometry']['coordinates']) {
          coordinates.add([coord[1], coord[0]]);
        }
        return coordinates;
      } else {
        throw Exception('Failed to fetch route: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération de l\'itinéraire: $e');
      throw Exception('Impossible de récupérer l\'itinéraire.');
    }
  }
}
