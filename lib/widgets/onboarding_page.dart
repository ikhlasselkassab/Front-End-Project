import 'package:flutter/material.dart';


import '../utils/constants/sizes.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.defaultSpace), // Padding pour tout le contenu
      child: Column(
        mainAxisSize: MainAxisSize.min, // Réduit l'espace vertical inutilisé
        crossAxisAlignment: CrossAxisAlignment.center, // Centrage horizontal
        children: [
          Center(
            child: Image(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.5, // Taille réduite si nécessaire
              image: AssetImage(image),
            ),
          ),
          const SizedBox(height: 5), // Réduction de l'espacement entre l'image et le titre
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold, // Texte en gras
                  fontSize: 18, // Taille réduite
                  fontFamily: 'CustomFont', // Police personnalisée (si configurée)
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5), // Réduction de l'espacement entre le titre et le sous-titre
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
