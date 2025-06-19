import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/profile_state.dart';
import 'package:travel_muse_app/viewmodels/user/profile_view_model.dart';

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
    );
