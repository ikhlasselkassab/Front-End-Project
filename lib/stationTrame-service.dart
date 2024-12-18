import 'package:http/http.dart' as http;
import 'dart:convert';

class StationTrameService {
  final String apiUrl = 'http://localhost:8081/api/stations';

  Future<List<Station>> fetchStations() async {

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Accept': 'application/json; charset=UTF-8'}, // Assurer UTF-8
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((station) => Station.fromJson(station)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }


}

class Station {
  final String id;
  final double lat;
  final double lng;
  final String name;

  Station({required this.id, required this.lat, required this.lng, required this.name});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      name: json['name'],
    );
  }
}
