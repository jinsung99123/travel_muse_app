import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home_place.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceInfoSection extends StatelessWidget {
  const PlaceInfoSection({super.key, required this.place});

  final HomePlace place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (place.subtitle.isNotEmpty)
          Text('주소: ${place.subtitle}', style: theme.bodyMedium),
        const SizedBox(height: 4),
        if (place.phone != null && place.phone!.isNotEmpty)
          Text('전화: ${place.phone}', style: theme.bodyMedium),
        const SizedBox(height: 4),
        if (place.placeUrl != null && place.placeUrl!.isNotEmpty)
          GestureDetector(
            onTap: () => launchUrl(Uri.parse(place.placeUrl!)),
            child: Text(
              '홈페이지: ${place.placeUrl}',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }
}
