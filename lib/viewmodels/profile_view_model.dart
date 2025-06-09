import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class ProfileState {
  const ProfileState({
    this.nickname,
    this.profileImageUrl,
    this.temporaryImageUrl,
    this.birthDate,
    this.gender,
  });
  final String? nickname;
  final String? profileImageUrl;
  final String? temporaryImageUrl;
  final DateTime? birthDate;
  final String? gender;

  ProfileState copyWith({
    String? nickname,
    String? profileImageUrl,
    String? temporaryImageUrl,
    DateTime? birthDate,
    String? gender,
  }) {
    return ProfileState(
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      temporaryImageUrl: temporaryImageUrl ?? this.temporaryImageUrl,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
    );
  }
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;
  final formKeyNickname = GlobalKey<FormState>();
  final formKeyBirthDate = GlobalKey<FormState>();
  final nicknameController = TextEditingController();
  final birthDateController = TextEditingController();
  final _picker = ImagePicker();

  // 업로드된 이미지 url 임시 저장
  String? temporaryImageUrl;

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
      final isValid = formKeyNickname.currentState?.validate() ?? false;
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

  Future<String?> uploadProfileImage() async {
    try {
      if (currentUser == null) {
        log('currentUser is null');
        return null;
      }
      // 이미지 pick
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      final file = File(pickedFile.path);
      log('프로필 이미지 업로드 시도');
      final url = await appUserRepo.uploadProfileImage(
        uid: currentUser!.uid,
        file: file,
      );
      state = state.copyWith(temporaryImageUrl: url);

      return url;
    } catch (e) {
      log('프로필 이미지 업로드 실패 : $e');
      return null;
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    try {
      await appUserRepo.updateProfileImage(
        uid: currentUser!.uid,
        fileUrl: imageUrl,
      );

      state = state.copyWith(profileImageUrl: imageUrl);
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
