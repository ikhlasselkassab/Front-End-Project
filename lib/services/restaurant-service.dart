import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/restaurant.dart';




class RestaurantService {
  static final String baseUrl = 'http://localhost:8081/api';

  // Récupérer la liste des restaurants
  static Future<List<Restaurant>> fetchRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/restaurants'),
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Restaurant.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load restaurants: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des restaurants: $e');
      throw Exception('Impossible de récupérer les restaurants.');
    }
  }
}

