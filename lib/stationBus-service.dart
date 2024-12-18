import 'dart:convert';
import 'package:http/http.dart' as http;

class StationBus {
  final String id;
  final String name;
  final List<String> lines;
  final double lat;
  final double lng;

  StationBus({
    required this.id,
    required this.name,
    required this.lines,
    required this.lat,
    required this.lng,
  });

  // Convertir un JSON en instance de StationBus
  factory StationBus.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw ArgumentError("Le JSON ne peut pas être null.");
    }
    return StationBus(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lines: json['lines'] != null
          ? List<String>.from(json['lines']) // Convertir en liste de chaînes
          : [],
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
    );
  }

  // Fonction auxiliaire pour parser les coordonnées en double
  static double _parseDouble(dynamic value) {
    try {
      if (value != null) {
        return double.parse(value.toString());
      } else {
        return 0.0;
      }
    } catch (e) {
      print('Erreur de conversion en double pour la valeur: $value');
      return 0.0;
    }
  }
}

class StationBusService {
  static final String baseUrl = 'http://localhost:8081/api';

  static Future<List<StationBus>> fetchBusStations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/station/bus'), // Endpoint pour les stations de bus
        headers: {'Accept': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => StationBus.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load bus stations: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des stations de bus: $e');
      throw Exception('Impossible de récupérer les stations de bus.');
    }
  }
}
