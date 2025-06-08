import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/viewmodels/schedule_view_model.dart';

final scheduleViewModelProvider =
    StateNotifierProvider<ScheduleViewModel, AsyncValue<List<Plans>>>(
  (ref) => ScheduleViewModel(),
);
