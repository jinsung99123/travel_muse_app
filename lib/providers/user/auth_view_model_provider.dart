import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/user/auth_state.dart';
import 'package:travel_muse_app/viewmodels/user/auth_view_model.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);
