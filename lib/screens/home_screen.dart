import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Pour les polices modernes
import 'package:ikhl/screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> hotels = [
    {
      'name': 'Ibis Rabat Agdal',
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGmva1BPoLp794SBCbUXC4yD2W6zaZUH1vbg&s",
      'price': '\$999/night',
    },
    {
      'name': 'Rent Inn Suites Hôtel',
      'image': "https://cf.bstatic.com/xdata/images/hotel/max1024x768/324592866.jpg?k=16cbc191a558b4f6fe4d3b66ce7c936c7df8bda04a95fe969d18240b6784dd30&o=&hp=1",
      'price': '\$285/night',
    },
    {
      'name': 'Sofitel Rabat Jardin des Roses',
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTxfRGXgBnjYL20y-5TWA9LElBnca2s8YyyQ&s",
      'price': '\$419/night',
    },
    {
      'name': "Riad Dar Alia",
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSiVaaKtL-LwXMzexvRoGrj9Fo_G-0IvHtp9g&s",
      'price': '\$100/night',
    },
    {
      "name": "STORY Rabat",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTS-9POpJgjAS2wMjckUotDne8z1mNWqpmmIA&s",
      'price': '\$100/night',
    },
    {
      "name": "Myn in Rabat",
      "image": "https://lh3.googleusercontent.com/p/AF1QipMSympB7WNkkRU7KSWAlGBoM7DQA4O8b9NaDQRq=s1360-w1360-h1020",
      'price': '\$150/night',
    },
    {
      "name": "Riad à la Belle Etoile",
      "image": "https://lh3.googleusercontent.com/p/AF1QipMuNlj-Qr5Ju8nt569-acIGKsjVKdU5CAHYsiPs=s1360-w1360-h1020",
      'price': '\$200/night',
    },
  ];

  final List<Map<String, String>> restaurants = [
    {
      'name': 'Restaurant du Riad Kalaa',
      'image': "https://media-cdn.tripadvisor.com/media/photo-s/0f/c0/4b/bc/riad-kalaa.jpg",
      'type': 'Cuisine Marocaine',
    },
    {
      'name': 'Little Mamma Agdal',
      'image': "https://th.bing.com/th/id/OIP.IJKeaNjXu5pw0Rg-MBcQZQHaFj?rs=1&pid=ImgDetMain",
      'type': 'Cuisine Italienne',
    },
    {
      'name': 'Restaurant Abtal Alcham',
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfzEsyf_1tqA4oICv8hdjG-2O2G9OEjNZGA&s",
      'type': 'Cuisine Orientale',
    },
    {
      'name': "La Mamma",
      'image': "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/9b/8f/76/photo1jpg.jpg?w=1000&h=-1&s=1",
      'type': "Cuisine Italienne",
    },
    {
      'name': "Restaurant Sufra",
      'image': "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/19/4a/15/b0/aubergine-fatteh.jpg?w=1100&h=600&s=1",
      'type': "Orientale",
    },
    {
      'name': "Naga Thaï Cuisine",
      'image': "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/3b/dc/7a/cosy-and-warm.jpg?w=500&h=300&s=1",
      'type': "Asiatique",
    },
    {
      'name': "Shoko Lounge",
      'image': "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2a/ca/d3/68/shoko-lounge-rabat.jpg?w=1000&h=-1&s=1",
      'type': "Asiatique",
    }
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HotelMapScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Découvrez notre application',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hôtels recommandés",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blueGrey[900]!, Colors.blueGrey[700]!],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 20)),
                ),
              ),
              SizedBox(height: 10), // Virgule ajoutée ici
              _buildHorizontalList(hotels, 'price'),
              SizedBox(height: 20), // Virgule ajoutée ici
              Text(
                "Restaurants recommandés",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [Colors.blueGrey[900]!, Colors.blueGrey[700]!],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 20)),
                ),
              ),
              SizedBox(height: 10), // Virgule ajoutée ici
              _buildHorizontalList(restaurants, 'type'),
            ],
          ),
        ),
      )
          : HotelMapScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueGrey[900],
        unselectedItemColor: Colors.grey[600],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, String>> items,
      String detailKey) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.only(right: 16),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), // Coins arrondis
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // Ombre plus prononcée
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  // Coins arrondis pour l'image
                  child: Image.network(
                    item['image']!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  // Espacement interne ajusté
                  child: Text(
                    item['name']!,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey[900],
                    ),
                    maxLines: 2, // Limite le texte à 2 lignes
                    overflow: TextOverflow
                        .ellipsis, // Ajoute des points de suspension si le texte est trop long
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  // Espacement interne ajusté
                  child: Text(
                    item[detailKey]!,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}