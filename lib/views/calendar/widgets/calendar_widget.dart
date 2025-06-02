import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_muse_app/viewmodels/calendar_view_model.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_day_builder.dart';

class CalendarWidget extends StatelessWidget {
  final CalendarState state;
  final bool Function(DateTime) isSelected;
  final bool Function(DateTime) isBetween;
  final void Function(DateTime, DateTime) onDaySelected;

  const CalendarWidget({
    super.key,
    required this.state,
    required this.isSelected,
    required this.isBetween,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: state.focusedDay,
      selectedDayPredicate: isSelected,
      onDaySelected: onDaySelected,
      calendarBuilders: CalendarBuilders(
        defaultBuilder:
            (context, day, _) => buildDayCell(day, isBetween(day), false),
        selectedBuilder: (context, day, _) => buildDayCell(day, false, true),
      ),
    );
  }
}
