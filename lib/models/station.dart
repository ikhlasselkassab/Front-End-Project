class Station {
  final String id;
  final double lat;
  final double lng;
  final String name;
  final List<String> lines;

  Station({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name, 
    required this.lines,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] ?? '',
      lat: (json['lat'] as num).toDouble(), // Convertir en double
      lng: (json['lng'] as num).toDouble(), // Convertir en double
      name: json['name'] ?? 'Unknown',
      lines: json['lines'] != null
          ? List<String>.from(json['lines']) // Convertir explicitement en List<String>
          : [], // Utiliser une liste vide si null
    );
  }
}

