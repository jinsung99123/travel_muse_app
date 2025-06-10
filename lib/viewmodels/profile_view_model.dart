import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class ProfileState {
  const ProfileState({
    this.profileImageUrl,
    this.temporaryImagePath,
    this.gender,
    this.isGenderValid,
  });
  final String? profileImageUrl;
  final String? temporaryImagePath;
  final String? gender;
  final bool? isGenderValid;

  ProfileState copyWith({
    String? profileImageUrl,
    String? temporaryImagePath,
    String? gender,
    bool? isGenderValid,
  }) {
    return ProfileState(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      temporaryImagePath: temporaryImagePath ?? this.temporaryImagePath,
      gender: gender ?? this.gender,
      isGenderValid: isGenderValid ?? this.isGenderValid,
    );
  }
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;

  final _picker = ImagePicker();
  late File? pickedImage;

  // 업로드된 이미지 url 임시 저장
  String? temporaryImageUrl;

  @override
  ProfileState build() {
    return const ProfileState();
  }

  // 사용자가 고른 이미지 로컬에 저장
  Future<void> savePickedImageToLocal() async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    pickedImage = File(xfile.path);

    final directory = await getApplicationDocumentsDirectory();
    final customFolder = Directory('${directory.path}/profile_images');

    if (!await customFolder.exists()) {
      await customFolder.create(recursive: true); // 폴더가 없으면 생성
    }
    final fileName =
        'user_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localImagePath = '${customFolder.path}/$fileName';

    await File(pickedImage!.path).copy(localImagePath);

    log('이미지 저장 성공 : $localImagePath ');
    state = state.copyWith(temporaryImagePath: localImagePath);
  }

  // 프로필 이미지 업데이트
  Future<void> updateProfileImage() async {
    try {
      // 이미지 스토리지 업로드
      final imageUrl = await appUserRepo.uploadProfileImage(
        uid: currentUser!.uid,
        file: pickedImage!,
      );

      // 스토리지의 이미지 사용자 컬렉션에 업데이트
      await appUserRepo.updateProfileImage(
        uid: currentUser!.uid,
        fileUrl: imageUrl,
      );

      state = state.copyWith(profileImageUrl: imageUrl);
    } catch (e) {
      log('프로필 이미지 업데이트 실패 : $e');
    }
  }

  // db에서 프로필 이미지 가져오기
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

  // 성별 선택
  void selectGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  // 성별 선택 확인
  void isGenderValid() {
    if (state.gender == null) {
      state = state.copyWith(isGenderValid: false);
    } else {
      state = state.copyWith(isGenderValid: true);
    }
  }

  // 프로필 업데이트
  Future<void> updateProfile(String nickname, String birthDate) async {
    if (currentUser == null) return;

    final uid = currentUser!.uid;

    try {
      // 프로필이미지 업데이트
      if (temporaryImageUrl != null) {
        await updateProfileImage();
      }

      // 닉네임 업데이트
      await appUserRepo.updateNickname(uid: uid, nickname: nickname);

      // 생년월일 업데이트
      await appUserRepo.updateBirthDate(uid: uid, birthDate: birthDate);

      // 성별 업데이트
      await appUserRepo.updateGender(uid: uid, gender: state.gender!);
    } catch (e) {
      log('프로필 업데이트 실패: $e');
    }
  }
}

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
    );
