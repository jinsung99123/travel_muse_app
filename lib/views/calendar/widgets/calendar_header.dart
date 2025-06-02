import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget implements PreferredSizeWidget {
  const CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.onPrev,
    required this.onNext,
  });
  final DateTime focusedDay;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.yMMMM().format(focusedDay);

    return AppBar(
      title: Text(month, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Icons.arrow_back), onPressed: onPrev),
        IconButton(icon: const Icon(Icons.arrow_forward), onPressed: onNext),
      ],
    );
  }
}
