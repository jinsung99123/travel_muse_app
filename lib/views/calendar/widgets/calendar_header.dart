import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget implements PreferredSizeWidget {
  const CalendarHeader({super.key, required this.focusedDay});

  final DateTime focusedDay;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.yMMMM().format(focusedDay);

    return AppBar(
      title: Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
    );
  }
}
