import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import '../models/station.dart';
import 'hotel-service.dart';

class StationTrameService {
  static final String apiUrl = 'http://localhost:8081/api/stations';

  static Future<List<Station>> fetchStations() async {

    final response = await http.get(
        Uri.parse(apiUrl),
         headers: {'Accept': 'application/json; charset=UTF-8'},

    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((station) => Station.fromJson(station)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

 






}

