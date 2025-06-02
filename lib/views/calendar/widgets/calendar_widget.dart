import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_day_builder.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_utils.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.state,
    required this.onDaySelected,
  });
  final CalendarSelectionState state;
  final void Function(DateTime, DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: state.focusedDay,
      selectedDayPredicate: (day) => state.isSelected(day),
      onDaySelected: onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder:
            (context, day, _) => buildDayCell(day, state, selected: false),
        selectedBuilder:
            (context, day, _) => buildDayCell(day, state, selected: true),
      ),
    );
  }
}
