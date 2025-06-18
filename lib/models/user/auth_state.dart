import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_muse_app/models/user/app_user_model.dart';

class AuthState {
  AuthState({this.user, this.appUser, this.isUserNew = false});

  final User? user;
  final AppUser? appUser;
  final bool isUserNew;

  AuthState copyWith({User? user, AppUser? appUser, bool? isUserNew}) {
    return AuthState(
      user: user ?? this.user,
      appUser: appUser ?? this.appUser,
      isUserNew: isUserNew ?? this.isUserNew,
    );
  }
}
