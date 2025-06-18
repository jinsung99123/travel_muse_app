import 'package:flutter/material.dart';

Widget buildDayCell(DateTime day, bool isInRange, bool selected) {
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
          fontFamily: '',
          fontSize: 20,
          color: selected ? Colors.white : null,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
