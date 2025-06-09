import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/province_box_item.dart';

class ProvinceBoxList extends StatelessWidget {
  const ProvinceBoxList({
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
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return ProvinceBoxItem(
          label: items[index],
          isSelected: selectedIndices.contains(index),
          onTap: () => onTap(index),
        );
      },
    );
  }
}
