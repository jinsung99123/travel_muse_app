import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/selectable_box.dart';

class SelectableBoxList extends StatelessWidget {
  const SelectableBoxList({
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
    double boxWidth = (MediaQuery.of(context).size.width - 48) / 3;

    return Expanded(
      child: Wrap(
        spacing: 8,
        runSpacing: 10,
        children: List.generate(items.length, (index) {
          bool isSelected = selectedIndices.contains(index);

          return SelectableBox(
            text: items[index],
            width: boxWidth,
            isSelected: isSelected,
            onTap: () => onTap(index),
          );
        }),
      ),
    );
  }
}
