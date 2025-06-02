import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/schedule_place_card.dart';

class DayScheduleSection extends StatelessWidget {
  const DayScheduleSection({
    super.key,
    required this.dayIndex,
    required this.dayLabel,
    required this.schedules,
    required this.isEditing,
    required this.onReorder,
    required this.onAddPlace,
  });
  final int dayIndex;
  final String dayLabel;
  final List<Map<String, String>> schedules;
  final bool isEditing;
  final void Function(int dayIndex, int oldIndex, int newIndex) onReorder;
  final void Function(int dayIndex) onAddPlace;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'day ${dayIndex + 1} $dayLabel',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedules.length,
            onReorder: isEditing
                ? (oldIndex, newIndex) =>
                    onReorder(dayIndex, oldIndex, newIndex)
                : (_, __) {},
            buildDefaultDragHandles: false,
            itemBuilder: (context, i) {
              final place = schedules[i];
              return Container(
                key: ValueKey('$dayIndex-$i'),
                child: ReorderableDragStartListener(
                  index: i,
                  enabled: isEditing,
                  child: SchedulePlaceCard(
                    index: i + 1,
                    place: place,
                    showHandle: isEditing,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => onAddPlace(dayIndex),
            child: const Text('장소 추가'),
          ),
        ],
      ),
    );
  }
}
