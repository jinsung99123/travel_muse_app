import 'package:flutter/material.dart';

class PlaceStatsRow extends StatelessWidget {
  const PlaceStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.star, color: Colors.amber, size: 20),
        SizedBox(width: 4),
        Text("4.6 (1200)", style: TextStyle(fontSize: 14)),
        SizedBox(width: 12),
        Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
        SizedBox(width: 4),
        Text("9,824", style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
