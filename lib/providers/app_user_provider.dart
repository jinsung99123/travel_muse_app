import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/app_user_model.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

final appUserProvider = FutureProvider<AppUser?>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final appUserRepo = AppUserRepository();
  if (currentUser != null) {
    return await appUserRepo.fetchLatestAppUser(currentUser.uid);
  }
  return null;
});
