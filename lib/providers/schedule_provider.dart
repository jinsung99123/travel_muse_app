import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/plans.dart';
import 'package:travel_muse_app/repositories/schedule_repository.dart';
import 'package:travel_muse_app/viewmodels/schedule_view_model.dart';

/// Repository Provider (의존성 주입)
final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) => ScheduleRepository(),
);

/// ViewModel Provider
final scheduleViewModelProvider =
    StateNotifierProvider<ScheduleViewModel, AsyncValue<List<Plans>>>(
  (ref) {
    final repository = ref.read(scheduleRepositoryProvider);
    return ScheduleViewModel(repository);
  },
);
