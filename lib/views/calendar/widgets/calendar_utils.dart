class CalendarSelectionState {
  DateTime focusedDay = DateTime.now();
  DateTime? startDay;
  DateTime? endDay;

  void selectDay(DateTime selectedDay, DateTime newFocusedDay) {
    focusedDay = newFocusedDay;

    if (startDay == null || (startDay != null && endDay != null)) {
      startDay = selectedDay;
      endDay = null;
    } else if (startDay != null && endDay == null) {
      if (selectedDay.isBefore(startDay!)) {
        endDay = startDay;
        startDay = selectedDay;
      } else {
        endDay = selectedDay;
      }
    }
  }

  void goToPreviousMonth() {
    focusedDay = DateTime(focusedDay.year, focusedDay.month - 1, 1);
  }

  void goToNextMonth() {
    focusedDay = DateTime(focusedDay.year, focusedDay.month + 1, 1);
  }

  bool isSelected(DateTime day) {
    return day == startDay || day == endDay;
  }

  bool isBetween(DateTime day) {
    if (startDay == null || endDay == null) return false;
    return day.isAfter(startDay!) && day.isBefore(endDay!);
  }
}
