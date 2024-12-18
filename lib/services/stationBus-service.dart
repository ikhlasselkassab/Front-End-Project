import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/stationBus.dart';


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
