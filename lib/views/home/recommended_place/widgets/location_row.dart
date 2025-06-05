import 'package:flutter/material.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.location_on, color: Colors.grey, size: 18),
        SizedBox(width: 4),
        Text('경기 양평군 양서면', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
