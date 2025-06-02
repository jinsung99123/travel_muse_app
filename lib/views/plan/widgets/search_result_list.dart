
import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/widgets/plan_place_card.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({super.key, required this.places});
  final List<Map<String, String>> places;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        return PlanPlaceCard(place: places[index]);
      },
    );
  }
}
