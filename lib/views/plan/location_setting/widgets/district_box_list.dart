import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/district_box_item.dart';

class DistrictBoxList extends StatelessWidget {
  const DistrictBoxList({
    required this.items,
    required this.selectedIndices,
    required this.onTap,
    super.key,
  });

  final List<String> items;
  final Set<int> selectedIndices;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return DistrictBoxItem(
          width: double.infinity,
          height: 80,
          text: items[index],
          isSelected: selectedIndices.contains(index),
          onTap: () => onTap(index),
        );
      },
    );
  }
}
