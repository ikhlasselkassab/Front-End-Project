import 'dart:convert';
import 'package:http/http.dart' as http;

class Restaurant {
  final String nom;
  final double latitude;
  final double longitude;
  final String adresse;
  final String categorie;
  final String numero_de_telephone;
  final String horaires;
  final String image;

  Restaurant({
    required this.nom,
    required this.latitude,
    required this.longitude,
    required this.adresse,
    required this.categorie,
    required this.numero_de_telephone,
    required this.horaires,
    required this.image,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError("Le JSON ne peut pas être null.");
    }
    return Restaurant(
      nom: json['nom'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      adresse: json['adresse'] ?? '',
      categorie: json['categorie'] ?? '',
      numero_de_telephone: json['numero_de_telephone'] ?? '',
      horaires: json['horaires'] ?? '',
      image: json['image'] ?? '',
    );
  }
}


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

