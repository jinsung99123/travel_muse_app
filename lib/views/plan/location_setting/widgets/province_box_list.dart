import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/province_box_item.dart';

class ProvinceBoxList extends StatelessWidget {
  const ProvinceBoxList({
    required this.items,
    required this.emojis,
    required this.selectedIndices,
    required this.onTap,
    super.key,
  });

  final List<String> items;
  final List<String> emojis;
  final Set<int> selectedIndices;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 130,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return ProvinceBoxItem(
            label: items[index],
            emoji: emojis[index],
            isSelected: selectedIndices.contains(index),
            onTap: () => onTap(index),
          );
        },
      ),
    );
  }
}
