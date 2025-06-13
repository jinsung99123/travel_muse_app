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
    this.currentNickname,
    this.nicknameInput,
    this.isNicknameValid,
    this.nicknameMessage,
    this.isNicknameDuplicate,
    this.buttonState = '확인 불가',
    this.birthDateInput,
    this.isBirthDateValid,
    this.birthDateMessage,
    this.canCheckBirthDate = false,
    this.gender,
    this.isGenderValid,
    this.canUpdateProfile = false,
    this.canEditProfile = false,
  });
  final String? profileImageUrl;
  final String? temporaryImagePath;
  final String? currentNickname;
  final String? nicknameInput;
  final bool? isNicknameValid;
  final String? nicknameMessage;
  final bool? isNicknameDuplicate;
  final String buttonState;
  final String? birthDateInput;
  final bool? isBirthDateValid;
  final String? birthDateMessage;
  final bool canCheckBirthDate;
  final String? gender;
  final bool? isGenderValid;
  final bool canUpdateProfile;
  final bool canEditProfile;

  ProfileState copyWith({
    String? profileImageUrl,
    String? temporaryImagePath,
    String? currentNickname,
    String? nicknameInput,
    bool? isNicknameValid,
    String? nicknameMessage,
    bool? isNicknameDuplicate,
    String? buttonState,
    String? birthDateInput,
    bool? isBirthDateValid,
    String? birthDateMessage,
    bool? canCheckBirthDate,
    String? gender,
    bool? isGenderValid,
    bool? canUpdateProfile,
    bool? canEditProfile,
  }) {
    return ProfileState(
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      temporaryImagePath: temporaryImagePath ?? this.temporaryImagePath,
      currentNickname: currentNickname ?? this.currentNickname,
      nicknameInput: nicknameInput ?? this.nicknameInput,
      isNicknameValid: isNicknameValid ?? this.isNicknameValid,
      nicknameMessage: nicknameMessage ?? this.nicknameMessage,
      isNicknameDuplicate: isNicknameDuplicate ?? this.isNicknameDuplicate,
      buttonState: buttonState ?? this.buttonState,
      birthDateInput: birthDateInput ?? this.birthDateInput,
      isBirthDateValid: isBirthDateValid ?? this.isBirthDateValid,
      birthDateMessage: birthDateMessage ?? this.birthDateMessage,
      canCheckBirthDate: canCheckBirthDate ?? this.canCheckBirthDate,
      gender: gender ?? this.gender,
      isGenderValid: isGenderValid ?? this.isGenderValid,
      canUpdateProfile: canUpdateProfile ?? this.canUpdateProfile,
      canEditProfile: canEditProfile ?? this.canEditProfile,
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

  Future<void> loadUserData() async {
    if (currentUser != null) {
      log('currentUSer != null');
      final appUser = await appUserRepo.fetchLatestAppUser(currentUser!.uid);
      if (appUser != null) {
        state = state.copyWith(currentNickname: appUser.nickname);
        log('appUser != null');
        if (state.currentNickname != null) {
          state = state.copyWith(buttonState: '확인 완료');
        }
      }
    }
  }

  @override
  ProfileState build() {
    loadUserData();
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
    checkEditAvailable();
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

  // db에서 프로필 이미지, 닉네임 가져오기
  Future<void> fetchUserProfile() async {
    try {
      if (currentUser == null) return;
      final appUser = await appUserRepo.fetchLatestAppUser(currentUser!.uid);
      if (appUser == null) return;
      state = state.copyWith(
        currentNickname: appUser.nickname,
        profileImageUrl: appUser.profileImage,
      );
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
    state = state.copyWith(nicknameInput: value);
    if (state.nicknameInput != null && state.nicknameInput!.isNotEmpty) {
      state = state.copyWith(buttonState: '확인 필요');
    }
    if (state.nicknameInput != null) {
      if (state.nicknameInput!.isEmpty) {
        state = state.copyWith(buttonState: '확인 불가');
      }
    }
  }

  void resetNickname() {
    state = state.copyWith(
      isNicknameValid: null,
      isNicknameDuplicate: null,
      nicknameMessage: _defaultNicknameMessage,
    );
  }

  // validator 실행
  void validateNickname() {
    final nicknameErrorText = Validators.validateNickname(state.nicknameInput);
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
  Future<void> isNicknameDuplicate() async {
    if (state.isNicknameDuplicate == null) {
      state = state.copyWith(nicknameMessage: null);
    }
    if (state.nicknameInput == null) return;

    try {
      final checkIsDuplicate = await appUserRepo.isNicknameDuplicate(
        state.nicknameInput!,
      );
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
    } catch (e) {
      log('닉네임 중복 확인 실패 : $e');
    }
    checkUpdateAvailable();
  }

  // 닉네임 사용 가능 여부 확인
  Future<bool> checkCanUseNickname() async {
    if (state.nicknameInput == null) return false;
    validateNickname();
    if (state.isNicknameValid == null) return false;
    if (!state.isNicknameValid!) return false;
    await isNicknameDuplicate();
    if (state.isNicknameDuplicate == null) return false;
    if (state.isNicknameDuplicate!) return false;
    state = state.copyWith(buttonState: '확인 완료');
    checkEditAvailable();
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
        canCheckBirthDate: true,
      );
    }
    final isBlank = value.trim().isEmpty;
    state = state.copyWith(canCheckBirthDate: !isBlank, birthDateInput: value);

    if (state.canCheckBirthDate) {
      validateBirthDate();
    }
  }

  // validator 실행
  void validateBirthDate() {
    if (state.birthDateInput == null) return;
    final errorMessage = Validators.validateBirthDate(state.birthDateInput);
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
    // 닉네임 확인
    if (state.isNicknameValid != true || state.isNicknameDuplicate == true) {
      state = state.copyWith(canUpdateProfile: false);
      return;
    }
    // 생년월일 확인
    if (state.isBirthDateValid != true) {
      state = state.copyWith(canUpdateProfile: false);
      return;
    }
    // 성별 확인
    if (state.isGenderValid != true) {
      state = state.copyWith(canUpdateProfile: false);
      return;
    }
    state = state.copyWith(canUpdateProfile: true);
  }

  // 프로필 업데이트
  // 회원가입 시
  Future<void> updateProfile() async {
    if (currentUser == null) return;
    if (state.nicknameInput == null) return;
    if (state.birthDateInput == null) return;

    final uid = currentUser!.uid;

    try {
      // 프로필이미지 업데이트
      if (state.temporaryImagePath != null) {
        await updateProfileImage();
      }

      // 닉네임 업데이트
      await appUserRepo.updateNickname(
        uid: uid,
        nickname: state.nicknameInput!,
      );

      // 생년월일 업데이트
      await appUserRepo.updateBirthDate(
        uid: uid,
        birthDate: state.birthDateInput!,
      );

      // 성별 업데이트
      await appUserRepo.updateGender(uid: uid, gender: state.gender!);
    } catch (e) {
      log('프로필 업데이트 실패: $e');
    }
  }

  // 수정 가능 여부 확인
  void checkEditAvailable() {
    if (state.temporaryImagePath != null) {
      state = state.copyWith(canEditProfile: true);
    }
    // 닉네임 확인
    if (state.isNicknameValid == true && state.isNicknameDuplicate == false) {
      state = state.copyWith(canEditProfile: true);
    }
  }

  // 프로필 수정
  // 마이페이지 - 프로필 수정
  Future<void> editProfile() async {
    if (currentUser == null) return;

    final uid = currentUser!.uid;

    // 프로필이미지 업데이트
    if (state.temporaryImagePath != null) {
      await updateProfileImage();
    }
    // 닉네임 업데이트
    if (state.nicknameInput != null) {
      await appUserRepo.updateNickname(
        uid: uid,
        nickname: state.nicknameInput!,
      );
    }
  }
}

final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, ProfileState>(
      () => ProfileViewModel(),
    );
