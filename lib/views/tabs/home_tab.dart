import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/home/home_place.dart';
import 'package:travel_muse_app/views/home/home_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_place_detail_page.dart';
import 'package:travel_muse_app/views/home/recommended_place/recommended_restaurant_list_page.dart';
import 'package:travel_muse_app/views/my_page/plan_list_page.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const HomePage());
        }
        if (settings.name == '/recommended_detail') {
          final place = settings.arguments as HomePlace;
          return MaterialPageRoute(
            builder: (_) => RecommendedPlaceDetailPage(place: place),
          );
        }
        if (settings.name == '/plan_list') {
          return MaterialPageRoute(builder: (_) => PlanListPage());
        }
        if (settings.name == '/restaurant_list') {
          return MaterialPageRoute(
            builder: (_) => RecommendedRestaurantsListPage(),
          );
        }
        return null;
      },
    );
  }
}
