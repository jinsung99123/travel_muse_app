import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/app_user_state_model.dart';
import 'package:travel_muse_app/viewmodels/user/app_user_view_model.dart';

final appUserViewModelProvider =
    AutoDisposeAsyncNotifierProvider<AppUserViewModel, AppUserState>(
      () => AppUserViewModel(),
    );
