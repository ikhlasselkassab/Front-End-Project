class Hotel {
  final String name;
  final double latitude;
  final double longitude;
  final String description;
  final String adresse;
  final String image;
  final String url;
  final int etoiles;

  Hotel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.adresse,
    required this.image,
    required this.url,
    required this.etoiles
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
        name: json['name'],
        latitude: json['latitude'].toDouble(), // Conversion explicite en double
        longitude: json['longitude'].toDouble(),
        description: json['description'],
        adresse: json['adresse'],
        image : json['image'],
        url: json['url'],
        etoiles: json['etoiles']


    );
  }
}