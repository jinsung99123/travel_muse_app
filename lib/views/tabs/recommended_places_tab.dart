import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_places_list_page.dart';

class RecommendedPlacesTab extends StatelessWidget {
  const RecommendedPlacesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => const RecommendedPlacesListPage(),
          );
        }
        if (settings.name == '/recommended_detail') {
          final place = settings.arguments as HomePlace;
          return MaterialPageRoute(
            builder: (_) => RecommendedPlaceDetailPage(place: place),
          );
        }
        return null;
      },
    );
  }
}
