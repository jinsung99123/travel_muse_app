import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plan/calendar_model.dart';
import 'package:travel_muse_app/viewmodels/plan/calendar_view_model.dart';

final calendarViewModelProvider =
    StateNotifierProvider<CalendarViewModel, CalendarState>(
      (ref) => CalendarViewModel(),
    );
