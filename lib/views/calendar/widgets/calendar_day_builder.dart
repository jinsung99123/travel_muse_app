import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_utils.dart';

Widget buildDayCell(
  DateTime day,
  CalendarSelectionState state, {
  required bool selected,
}) {
  final isInRange = state.isBetween(day);

  return Container(
    margin: const EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      color:
          selected
              ? Colors.blue
              : isInRange
              ? Colors.lightBlue.shade100
              : null,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Center(
      child: Text(
        '${day.day}',
        style: TextStyle(
          color: selected ? Colors.white : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
