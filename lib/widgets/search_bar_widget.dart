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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 201, 143, 211),
                  width: 2,
                ),
              ),
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
                        hintText: 'Hotels, restaurants, tram, bus ...',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSearchPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              textStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Tracer Itinéraire'),
          ),
        ],
      ),
    );
  }
}
