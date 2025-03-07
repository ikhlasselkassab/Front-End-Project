class Hotel {
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String adresse;
  final String image;
  final String url;
  final int etoiles;
  final  String quartier;

  Hotel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.adresse,
    required this.image,
    required this.url,
    required this.etoiles,
    required this.quartier
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        name: json['name'] ?? "",
        latitude: json['latitude'].toDouble() ?? 0.0, // Conversion explicite en double
        longitude: json['longitude'].toDouble() ?? 0.0,
        description: json['description'],
        adresse: json['adresse'],
        image : json['image'],
        url: json['url'],
        etoiles: json['etoiles'],
        quartier:json['quartier']


    );
  }
}