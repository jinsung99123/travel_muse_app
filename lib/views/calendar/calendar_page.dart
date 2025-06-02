import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_header.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_utils.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final calendarState = CalendarSelectionState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarHeader(
        focusedDay: calendarState.focusedDay,
        onPrev: () => setState(calendarState.goToPreviousMonth),
        onNext: () => setState(calendarState.goToNextMonth),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CalendarWidget(
          state: calendarState,
          onDaySelected:
              (selectedDay, focusedDay) => setState(
                () => calendarState.selectDay(selectedDay, focusedDay),
              ),
        ),
      ),
    );
  }
}
