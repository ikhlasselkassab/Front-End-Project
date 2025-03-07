import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class VibratingMarker extends StatefulWidget {
  @override
  _VibratingMarkerState createState() => _VibratingMarkerState();
}

class _VibratingMarkerState extends State<VibratingMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(0.6),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
