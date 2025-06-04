import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/calendar_model.dart';
import 'package:travel_muse_app/viewmodels/calendar_view_model.dart';

final calendarViewModelProvider =
    StateNotifierProvider<CalendarViewModel, CalendarState>(
      (ref) => CalendarViewModel(),
    );
