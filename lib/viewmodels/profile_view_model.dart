import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class ProfileState {
  const ProfileState({this.nickname, this.profileImageUrl});
  final String? nickname;
  final String? profileImageUrl;

  ProfileState copyWith({String? nickname, String? profileImageUrl}) {
    return ProfileState(
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final _picker = ImagePicker();

  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> updateNickname() async {
    try {
      if (currentUser == null) {
        log('currentUser is null');
        return;
      }

      // 닉네임 validator 확인
      final isValid = formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      // 닉네임 업데이트
      log(
        '닉네임 업데이트 시도 - user ${currentUser!.uid}, 새 닉네임 : ${nicknameController.text}',
      );
      await appUserRepo.updateNickname(
        uid: currentUser!.uid,
        nickname: nicknameController.text,
      );
    } catch (e) {
      log('닉네임 업데이트 실패 : $e');
    }
  }

  Future<void> updateProfileImage() async {
    try {
      if (currentUser == null) {
        log('currentUser is null');
        return;
      }
      // 이미지 pick
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      log('프로필 이미지 업데이트 시도');
      await appUserRepo.uploadProfileImage(uid: currentUser!.uid, file: file);
      await fetchProfileImageUrl();
    } catch (e) {
      log('프로필 이미지 업데이트 실패 : $e');
    }
  }

  Future<void> fetchProfileImageUrl() async {
    try {
      if (currentUser == null) return;

      final doc =
          await FirebaseFirestore.instance
              .collection('appUser')
              .doc(currentUser!.uid)
              .get();

      final url = doc.data()?['profileImage'];

      if (url is String && url.isNotEmpty) {
        state = state.copyWith(profileImageUrl: url);
        log('프로필 이미지 로드 완료: $url');
      }
    } catch (e) {
      log('프로필 이미지 로드 실패: $e');
    }
  }
}

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
    );
