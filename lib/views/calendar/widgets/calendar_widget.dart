import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_muse_app/viewmodels/calendar_view_model.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_day_builder.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.state,
    required this.isSelected,
    required this.isBetween,
    required this.onDaySelected,
  });
  final CalendarState state;

  // 특정 날짜가 선택된 날짜인지 확인
  final bool Function(DateTime) isSelected;

  // 특정 날짜가 선택된 날짜 사이에 있는지 확인
  final bool Function(DateTime) isBetween;

  final void Function(DateTime, DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // 선택 가능한 날짜 범위
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),

      focusedDay: state.focusedDay,
      selectedDayPredicate: isSelected,
      onDaySelected: onDaySelected,

      // 날짜 셀을 커스터마이징 하기 위한 빌더
      calendarBuilders: CalendarBuilders(
        defaultBuilder:
            (context, day, _) => buildDayCell(day, isBetween(day), false),

        selectedBuilder: (context, day, _) => buildDayCell(day, false, true),
      ),
    );
  }
}
