class CalendarState {
  CalendarState({required this.focusedDay, this.startDay, this.endDay});

  final DateTime focusedDay;
  final DateTime? startDay;
  final DateTime? endDay;

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? startDay,
    DateTime? endDay,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      startDay: startDay,
      endDay: endDay,
    );
  }
}
