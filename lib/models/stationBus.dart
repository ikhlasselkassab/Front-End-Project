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
