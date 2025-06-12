import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home_place.dart';

class LocationRow extends StatelessWidget {
  const LocationRow({super.key, required this.place});

  final HomePlace place;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.grey, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            place.subtitle,
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
