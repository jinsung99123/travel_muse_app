import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:travel_muse_app/views/calendar/widgets/calendar_day_builder.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.month,
    required this.isSelected,
    required this.isBetween,
    required this.onDaySelected,
  });

  final DateTime month;
  final bool Function(DateTime) isSelected;
  final bool Function(DateTime) isBetween;
  final void Function(DateTime, DateTime) onDaySelected;

  @override
  Widget build(BuildContext context) {
    final monthText = '${month.year}년 ${month.month}월';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey[200]!, width: 1.5),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                monthText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const SizedBox(height: 8),
            TableCalendar(
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: month,
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
              selectedDayPredicate: isSelected,
              onDaySelected: onDaySelected,
              calendarStyle: const CalendarStyle(outsideDaysVisible: false),
              availableGestures: AvailableGestures.none,
              daysOfWeekHeight: 30,
              daysOfWeekStyle: DaysOfWeekStyle(
                dowTextFormatter: (date, locale) {
                  const koreanWeekdays = ['월', '화', '수', '목', '금', '토', '일'];
                  return koreanWeekdays[date.weekday - 1];
                },
                weekdayStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.5,
                ),
                weekendStyle: TextStyle(
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder:
                    (context, day, _) =>
                        buildDayCell(day, isBetween(day), false),
                selectedBuilder:
                    (context, day, _) => buildDayCell(day, false, true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
