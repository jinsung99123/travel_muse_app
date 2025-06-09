import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/place_search/widgets/plan_place_card.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
    super.key,
    required this.places,
    required this.selectedIndexes,
    required this.onToggle,
  });

  final List<Map<String, String>> places;
  final Set<int> selectedIndexes;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final isSelected = selectedIndexes.contains(index);

        return GestureDetector(
          onTap: () => onToggle(index),
          child: PlanPlaceCard(
            place: place,
            selected: isSelected,
          ),
        );
      },
    );
  }
}
