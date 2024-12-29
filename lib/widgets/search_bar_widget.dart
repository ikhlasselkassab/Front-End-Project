import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final List<String> destinations;
  final Function(String?) onDestinationSelected;
  final VoidCallback onSearchPressed;

  const SearchBarWidget({
    required this.destinations,
    required this.onDestinationSelected,
    required this.onSearchPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return destinations.where((destination) =>
                      destination.toLowerCase().contains(
                          textEditingValue.text.toLowerCase()));
                },
                onSelected: (String selection) {
                  onDestinationSelected(selection);
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Cherchez un hotel , un restaurant ,l\'aéroport, les trames , les gares ....',
                      border: InputBorder.none,
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.blue),
            onPressed: onSearchPressed,
          ),
        ],
      ),
    );
  }
}
