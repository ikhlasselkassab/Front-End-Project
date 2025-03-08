import 'package:flutter/material.dart';
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
      'image':"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGmva1BPoLp794SBCbUXC4yD2W6zaZUH1vbg&s", // URL réelle
      'price': '\$999/night',
    },
    {
      'name': 'Rent Inn Suites Hôtel',
      'image': "https://cf.bstatic.com/xdata/images/hotel/max1024x768/324592866.jpg?k=16cbc191a558b4f6fe4d3b66ce7c936c7df8bda04a95fe969d18240b6784dd30&o=&hp=1", // URL réelle
      'price': '\$285/night',
    },
    {
      'name': 'Sofitel Rabat Jardin des Roses',
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTxfRGXgBnjYL20y-5TWA9LElBnca2s8YyyQ&s", // URL réelle
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
      'image': "https://media-cdn.tripadvisor.com/media/photo-s/0f/c0/4b/bc/riad-kalaa.jpg", // URL réelle
      'type': ' Cuisine Marocaine',
    },
    {
      'name': 'Little Mamma Agdal',
      'image': "https://th.bing.com/th/id/OIP.IJKeaNjXu5pw0Rg-MBcQZQHaFj?rs=1&pid=ImgDetMain", // URL réelle
      'type': 'Cuisine Italienne',
    },
    {
      'name': 'Restaurant Abtal Alcham',
      'image': "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfzEsyf_1tqA4oICv8hdjG-2O2G9OEjNZGA&s", // URL réelle
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
      'image': "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/2a/ca/d3/68/shoko-lounge-rabat.jpg?w=1000&h=-1&s=1 ",
      'type': "Asiatique",
    }



  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Si l'utilisateur clique sur "Map", naviguer vers l'écran de la carte
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
            style: TextStyle(
              fontWeight: FontWeight.bold, // Appliquer le style gras
            )),
        backgroundColor: const Color.fromARGB(255, 179, 217, 218),
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "hôtels recommandés",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildHorizontalList(hotels, 'price'),
              SizedBox(height: 20),
              Text(
                " Restaurants recommandés",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildHorizontalList(restaurants, 'type'),
            ],
          ),
        ),
      )
          : HotelMapScreen(), // L'écran de la carte quand l'index est 1
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  Widget _buildHorizontalList(List<Map<String, String>> items, String detailKey) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: EdgeInsets.only(right: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      item['image']!,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item['name']!,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      item[detailKey]!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}