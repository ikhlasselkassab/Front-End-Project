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