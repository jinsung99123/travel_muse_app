import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDay;
  DateTime? _endDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;

      if (_startDay == null || (_startDay != null && _endDay != null)) {
        _startDay = selectedDay;
        _endDay = null;
      } else if (_startDay != null && _endDay == null) {
        if (selectedDay.isBefore(_startDay!)) {
          _endDay = _startDay;
          _startDay = selectedDay;
        } else {
          _endDay = selectedDay;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('달력'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2000, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => day == _startDay || day == _endDay,
          onDaySelected: _onDaySelected,
        ),
      ),
    );
  }
}
