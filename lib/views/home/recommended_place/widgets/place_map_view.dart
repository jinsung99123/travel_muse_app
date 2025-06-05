import 'package:flutter/material.dart';

class PlaceMapView extends StatelessWidget {
  const PlaceMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset('assets/images/image2.png'),
    );
  }
}
