import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/plan/plans.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/day_schedule_section.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/dotted_line_vertical.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/schedule_place_card.dart';

class DayScheduleList extends StatelessWidget {
  const DayScheduleList({
    super.key,
    required this.selectedPlan,
    required this.daySchedules,
    required this.isEditing,
    required this.expandedMap,
    required this.onToggleExpanded,
    required this.onReorder,
    required this.onAddPlace,
    required this.onRemovePlace,
    required this.onInsertPlace,
    this.onPlaceTap,
  });

  final Plans selectedPlan;
  final Map<int, List<Map<String, String>>> daySchedules;
  final bool isEditing;
  final Map<int, bool> expandedMap;
  final void Function(int dayIndex) onToggleExpanded;
  final void Function(int fromDay, int fromIndex, int toDay, int toIndex)
  onReorder;
  final Future<void> Function(int dayIndex) onAddPlace;
  final void Function(int dayIndex, int placeIndex) onRemovePlace;
  final void Function(int dayIndex, Map<String, String> place) onInsertPlace;
  final void Function(Map<String, String> place)? onPlaceTap;

  String _getWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dayCount =
        selectedPlan.endDate.difference(selectedPlan.startDate).inDays + 1;

    final lists = List.generate(dayCount, (dayIndex) {
      final currentDate = selectedPlan.startDate.add(Duration(days: dayIndex));
      final dayLabel =
          '${currentDate.month}.${currentDate.day} (${_getWeekday(currentDate.weekday)})';
      final isExpanded = expandedMap[dayIndex] ?? true;

      if (!isExpanded) {
        return DragAndDropList(
          header: DayScheduleSection(
            dayIndex: dayIndex,
            dayLabel: dayLabel,
            isExpanded: isExpanded,
            onToggle: () => onToggleExpanded(dayIndex),
          ),
          children: const [],
          contentsWhenEmpty: const SizedBox.shrink(), 
        );
      }

      daySchedules.putIfAbsent(dayIndex, () => []);
      final scheduleCards = <DragAndDropItem>[];

      if (isExpanded) {
        if (daySchedules[dayIndex]!.isEmpty) {
          scheduleCards.add(
            DragAndDropItem(
              canDrag: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const SizedBox(width: 24),
                    const DottedLineVertical(height: 116),
                    Spacer(),
                    Text(
                      '아직 추가된 일정이 없어요',
                      style: TextStyle(
                        color: AppColors.grey[400],
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        } else {
          scheduleCards.addAll(
            daySchedules[dayIndex]!.asMap().entries.map((entry) {
              final placeIndex = entry.key;
              final place = entry.value;

              return DragAndDropItem(
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 24),
                      const DottedLineVertical(height: 116),
                      const SizedBox(width: 23),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 1),
                          child: GestureDetector(
                            onTap:
                                isEditing
                                    ? null
                                    : () => onPlaceTap?.call(place),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SchedulePlaceCard(
                                    index: placeIndex + 1,
                                    place: place,
                                    showHandle: isEditing,
                                  ),
                                ),
                                if (isEditing)
                                  IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icons/x-circle.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    onPressed:
                                        () =>
                                            onRemovePlace(dayIndex, placeIndex),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              );
            }),
          );
        }

        // 일정 추가 버튼
        scheduleCards.add(
          DragAndDropItem(
            canDrag: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 47),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/icons/plus-circle.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed: () => onAddPlace(dayIndex),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      return DragAndDropList(
        header: DayScheduleSection(
          dayIndex: dayIndex,
          dayLabel: dayLabel,
          isExpanded: isExpanded,
          onToggle: () => onToggleExpanded(dayIndex),
        ),
        children: isExpanded ? scheduleCards : [],
        contentsWhenEmpty: isExpanded ? null : const SizedBox.shrink(),
      );
    });

    return DragAndDropLists(
      children: lists,
      onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
        if (isEditing) {
          onReorder(oldListIndex, oldItemIndex, newListIndex, newItemIndex);
        }
      },
      onListReorder: (_, __) {},
      listPadding: const EdgeInsets.only(bottom: 16),
      itemDragHandle: null,
      listDragHandle: null,
      listGhost: const SizedBox.shrink(),
    );
  }
}
