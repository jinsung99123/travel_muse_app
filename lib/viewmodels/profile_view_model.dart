import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travel_muse_app/core/validators.dart';
import 'package:travel_muse_app/repositories/app_user_repository.dart';

class ProfileState {
  const ProfileState({
    this.profileImageUrl,
    this.temporaryImagePath,
    this.isNicknameValid,
    this.nicknameMessage,
    this.canCheckNickname = false,
    this.isNicknameDuplicate,
    this.isBirthDateValid,
    this.birthDateMessage,
    this.canCheckBirthDate = false,
    this.gender,
    this.isGenderValid,
    this.canUpdateProfile = false,
  });
  final String? profileImageUrl;
  final String? temporaryImagePath;
  final bool? isNicknameValid;
  final String? nicknameMessage;
  final bool canCheckNickname;
  final bool? isNicknameDuplicate;
  final bool? isBirthDateValid;
  final String? birthDateMessage;
  final bool canCheckBirthDate;
  final String? gender;
  final bool? isGenderValid;
  final bool canUpdateProfile;

  ProfileState copyWith({
    String? profileImageUrl,
    String? temporaryImagePath,
    bool? isNicknameValid,
    String? nicknameMessage,
    bool? canCheckNickname,
    bool? isNicknameDuplicate,
    bool? isBirthDateValid,
    String? birthDateMessage,
    bool? canCheckBirthDate,
    String? gender,
    bool? isGenderValid,
    bool? canUpdateProfile,
  }) {
    return ProfileState(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      temporaryImagePath: temporaryImagePath ?? this.temporaryImagePath,
      isNicknameValid: isNicknameValid ?? this.isNicknameValid,
      nicknameMessage: nicknameMessage ?? this.nicknameMessage,
      canCheckNickname: canCheckNickname ?? this.canCheckNickname,
      isNicknameDuplicate: isNicknameDuplicate ?? this.isNicknameDuplicate,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
      birthDateMessage: birthDateMessage ?? this.birthDateMessage,
      canCheckBirthDate: canCheckBirthDate ?? this.canCheckBirthDate,
      gender: gender ?? this.gender,
      isGenderValid: isGenderValid ?? this.isGenderValid,
      canUpdateProfile: canUpdateProfile ?? this.canUpdateProfile,
    );
  }
}

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final appUserRepo = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;

  final _picker = ImagePicker();
  late File? pickedImage;

  static const String _defaultNicknameMessage = '최대 8자까지 입력 가능합니다';
  static const String _defaultBirthDateMessage = '주민등록상 생년월일 8자리를 입력해주세요';

  final nicknameController = TextEditingController();
  final birthDateController = TextEditingController();

  @override
  ProfileState build() {
    return ProfileState(
      nicknameMessage: _defaultNicknameMessage,
      birthDateMessage: _defaultBirthDateMessage,
    );
  }

  ///
  /// ------------------------------ 이미지 ----------------------------------
  ///

  // 업로드된 이미지 url 임시 저장
  String? temporaryImageUrl;

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

  ///
  /// ------------------------------ 닉네임 ----------------------------------
  ///

  // 사용자 입력 변경 감지
  void checkNicknameChanged(String value) {
    // 이미 중복확인 한 경우 : 확인된 isValid, isDuplicate를 reset
    if (state.isNicknameValid != null) {
      resetNickname();
    }
    // 중복 확인 가능한지 확인
    final isBlank = value.trim().isEmpty;
    state = state.copyWith(canCheckNickname: !isBlank);
  }

  void resetNickname() {
    state = const ProfileState(
      isNicknameValid: null,
      isNicknameDuplicate: null,
      nicknameMessage: _defaultNicknameMessage,
    );
  }

  // validator 실행
  void validateNickname(String value) {
    final nicknameErrorText = Validators.validateNickname(value);
    if (nicknameErrorText != null) {
      state = state.copyWith(
        isNicknameValid: false,
        nicknameMessage: nicknameErrorText,
      );
    } else {
      state = state.copyWith(isNicknameValid: true, nicknameMessage: null);
    }
  }

  // 중복 확인
  Future<void> isNicknameDuplicate(String nickname) async {
    if (state.isNicknameDuplicate == null) {
      state = state.copyWith(nicknameMessage: null);
    }
    final checkIsDuplicate = await appUserRepo.isNicknameDuplicate(nickname);
    state = state.copyWith(isNicknameDuplicate: checkIsDuplicate);
    if (checkIsDuplicate) {
      state = state.copyWith(
        isNicknameDuplicate: checkIsDuplicate,
        nicknameMessage: '이미 사용중인 닉네임입니다',
      );
    } else {
      state = state.copyWith(
        isNicknameDuplicate: checkIsDuplicate,
        nicknameMessage: '사용 가능한 닉네임입니다',
      );
    }
    checkUpdateAvailable();
  }

  // 닉네임 사용 가능 여부 확인
  Future<bool> checkCanUseNickname(String nickname) async {
    validateNickname(nickname);
    if (state.isNicknameValid == null) return false;
    if (!state.isNicknameValid!) return false;
    await isNicknameDuplicate(nickname);
    if (state.isNicknameDuplicate == null) return false;
    if (state.isNicknameDuplicate!) return false;

    return true;
  }

  // 닉네임 업데이트
  Future<void> updateNickname() async {
    if (state.isNicknameValid == null || state.isNicknameValid == false) {
      return;
    }

    try {
      if (currentUser == null) {
        log('currentUser is null');
        return;
      }

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

  ///
  /// ------------------------------ 생년월일 ----------------------------------
  ///

  // 사용자 입력 변경 감지
  void checkBirthDateChanged(String value) {
    if (state.isBirthDateValid != null) {
      state = state.copyWith(
        isBirthDateValid: null,
        birthDateMessage: null,
        canCheckBirthDate: false,
      );
    }
    final isBlank = value.trim().isEmpty;
    state = state.copyWith(canCheckBirthDate: !isBlank);

    if (state.canCheckBirthDate) {
      validateBirthDate(value);
    }
  }

  // validator 실행
  void validateBirthDate(String value) {
    final errorMessage = Validators.validateBirthDate(value);
    if (errorMessage != null) {
      state = state.copyWith(
        isBirthDateValid: false,
        birthDateMessage: errorMessage,
      );
    } else {
      state = state.copyWith(isBirthDateValid: true, birthDateMessage: null);
    }
    checkUpdateAvailable();
  }

  ///
  /// ------------------------------ 성별 ----------------------------------
  ///

  // 성별 선택
  void selectGender(String gender) {
    state = state.copyWith(gender: gender);

    // 성별 선택 확인
    if (state.gender == null) {
      state = state.copyWith(isGenderValid: false);
    } else {
      state = state.copyWith(isGenderValid: true);
    }
    checkUpdateAvailable();
  }

  ///
  /// ------------------------------ 전체 업데이트 ----------------------------------
  ///

  // 업데이트 가능 여부 확인(validator, 중복)
  void checkUpdateAvailable() {
    log('업데이트 가능 여부 확인');
    // 닉네임 확인
    if (state.isNicknameValid != true || state.isNicknameDuplicate == true) {
      return;
    }
    // 생년월일 확인
    if (state.isBirthDateValid != true) return;
    // 성별 확인
    if (state.isGenderValid != true) return;
    state = state.copyWith(canUpdateProfile: true);
    log('다음 버튼 활성화 가능');
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
      log('프로필 업데이트 완료');
    } catch (e) {
      log('프로필 업데이트 실패: $e');
    }
  }
}

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
    );
