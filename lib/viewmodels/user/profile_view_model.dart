import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:travel_muse_app/models/user/profile_state.dart';
import 'package:travel_muse_app/repositories/preference/preference_test_repository.dart';
import 'package:travel_muse_app/repositories/user/app_user_repository.dart';
import 'package:travel_muse_app/utills/validators.dart';

class ProfileViewModel extends AutoDisposeNotifier<ProfileState> {
  final _repository = AppUserRepository();
  final currentUser = FirebaseAuth.instance.currentUser;
  final repo = PreferenceTestRepository();

  final _picker = ImagePicker();
  late File? pickedImage;

  static const String _defaultNicknameMessage = '최대 8자까지 입력 가능합니다';
  static const String _defaultBirthDateMessage = '주민등록상 생년월일 8자리를 입력해주세요';

  final nicknameController = TextEditingController();
  final birthDateController = TextEditingController();

  @override
  ProfileState build() {
    fetchUserProfile();
    return ProfileState(
      nicknameMessage: _defaultNicknameMessage,
      birthDateMessage: _defaultBirthDateMessage,
      isUploading: false,
    );
  }

  /// db에서 기존 유저정보 가져오기
  Future<void> fetchUserProfile() async {
    try {
      if (currentUser == null) return;
      final appUser = await _repository.fetchLatestAppUser(currentUser!.uid);
      if (appUser == null) return;
      final firstTest = await repo.fetchFirstPreferenceTest(currentUser!.uid);
      final typeCode = firstTest?.result['type'];
      state = state.copyWith(
        currentNickname: appUser.nickname,
        profileImageUrl: appUser.profileImage,
        birthDateInput: appUser.birthDate,
        gender: appUser.gender,
        testId: appUser.testId,
        planId: appUser.planId,
        fallbackTypeCode: typeCode,
      );
      if (state.currentNickname != null) {
        state = state.copyWith(buttonState: '확인 완료');
      }
    } catch (e) {
      log('기존 유저정보 로드 실패: $e');
    }
  }

  ///
  /// ------------------------------ 이미지 ----------------------------------
  ///

  /// 사용자가 고른 이미지 리사이징 + 로컬에 저장
  Future<void> savePickedImageToLocal(int size) async {
    final xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile == null) return;
    pickedImage = File(xfile.path);

    final resized = await resizeImage(pickedImage!, size);
    if (resized == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final customFolder = Directory('${directory.path}/profile_images');

    if (!await customFolder.exists()) {
      await customFolder.create(recursive: true);
    }
    final fileName =
        'user_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localImagePath = '${customFolder.path}/$fileName';

    await resized.copy(localImagePath);

    log('이미지 저장 성공 : $localImagePath ');
    state = state.copyWith(temporaryImagePath: localImagePath);
    checkEditAvailable();
  }

  /// 이미지 리사이징
  Future<File?> resizeImage(File file, int size) async {
    final originalBytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(originalBytes);
    if (decodedImage == null) return null;

    final originalWidth = decodedImage.width;
    final originalHeight = decodedImage.height;

    int targetWidth, targetHeight;

    if (originalWidth < originalHeight) {
      targetWidth = size;
      targetHeight = (originalHeight * (size / originalWidth)).round();
    } else {
      targetHeight = size;
      targetWidth = (originalWidth * (size / originalHeight)).round();
    }

    final directory = await getTemporaryDirectory();
    final targetPath = path.join(
      directory.path,
      'resized_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: targetWidth,
      minHeight: targetHeight,
      quality: 85,
      format: CompressFormat.jpeg,
    );
    if (result != null) {
      log('리사이징 완료');
    }
    return result != null ? File(result.path) : null;
  }

  /// 프로필 이미지 업데이트
  Future<void> updateProfileImage() async {
    try {
      /// 로컬 이미지를 스토리지에 업로드
      final imageUrl = await _repository.uploadProfileImage(
        uid: currentUser!.uid,
        file: pickedImage!,
      );

      /// 스토리지의 이미지 url을 appUser profileImageUrl 필드에 업데이트
      await _repository.updateProfileImage(
        uid: currentUser!.uid,
        fileUrl: imageUrl,
      );

      state = state.copyWith(profileImageUrl: imageUrl);
    } catch (e) {
      log('프로필 이미지 업데이트 실패 : $e');
    }
  }

  /// 프로필 이미지 url 가져오기
  Future<void> fetchProfileImageUrl() async {
    if (currentUser == null) return;

    try {
      final url = await _repository.fetchProfileImageUrl(uid: currentUser!.uid);

      if (url != null) {
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

  /// 사용자 입력 변경 감지
  void checkNicknameChanged(String value) {
    /// 이미 중복확인 한 경우 : 확인된 isValid, isDuplicate를 reset
    if (state.isNicknameValid != null) {
      resetNicknameCheck();
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

  /// 닉네임 확인 결과를 초기화 - 중복 확인, validator 확인
  void resetNicknameCheck() {
    state = state.copyWith(
      isNicknameValid: null,
      isNicknameDuplicate: null,
      nicknameMessage: _defaultNicknameMessage,
    );
  }

  /// validator 실행
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

  /// 중복 확인
  Future<void> isNicknameDuplicate() async {
    if (state.isNicknameDuplicate == null) {
      state = state.copyWith(nicknameMessage: null);
    }
    if (state.nicknameInput == null) return;

    try {
      final checkIsDuplicate = await _repository.isNicknameDuplicate(
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

  /// 닉네임 사용 가능 여부 확인
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

  /// 닉네임 업데이트
  Future<void> updateNickname() async {
    if (state.isNicknameValid == null || state.isNicknameValid == false) {
      return;
    }

    try {
      if (currentUser == null) {
        log('currentUser is null');
        return;
      }

      log(
        '닉네임 업데이트 시도 - user ${currentUser!.uid}, 새 닉네임 : ${nicknameController.text}',
      );
      await _repository.updateNickname(
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

  /// 사용자 입력 변경 감지
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

  /// validator 실행
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

  /// 성별 선택
  void selectGender(String gender) {
    state = state.copyWith(gender: gender);

    /// 성별 선택 확인
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

  /// 업데이트 가능 여부 확인(validator, 중복)
  void checkUpdateAvailable() {
    /// 닉네임 확인
    if (state.isNicknameValid != true || state.isNicknameDuplicate == true) {
      state = state.copyWith(canUpdateProfile: false);
      return;
    }

    /// 생년월일 확인
    // if (state.isBirthDateValid != true) {
    //   state = state.copyWith(canUpdateProfile: false);
    //   return;
    // }
    // 성별 확인
    // if (state.isGenderValid != true) {
    //   state = state.copyWith(canUpdateProfile: false);
    //   return;
    // }
    state = state.copyWith(canUpdateProfile: true);
  }

  /// 프로필 업데이트
  /// 회원가입 시
  Future<void> updateProfile() async {
    if (currentUser == null) return;
    if (state.nicknameInput == null) return;
    // if (state.birthDateInput == null) return;

    final uid = currentUser!.uid;

    try {
      /// 프로필이미지 업데이트
      if (state.temporaryImagePath != null) {
        await updateProfileImage();
      }

      /// 닉네임 업데이트
      await _repository.updateNickname(
        uid: uid,
        nickname: state.nicknameInput!,
      );

      /// 생년월일 업데이트
      // await _repository.updateBirthDate(uid: uid, birthDate: state.birthDateInput!);

      /// 성별 업데이트
      // await _repository.updateGender(uid: uid, gender: state.gender!);
    } catch (e) {
      log('프로필 업데이트 실패: $e');
    }
  }

  /// 수정 가능 여부 확인
  void checkEditAvailable() {
    if (state.temporaryImagePath != null) {
      state = state.copyWith(canEditProfile: true);
    }

    /// 닉네임 확인
    if (state.isNicknameValid == true && state.isNicknameDuplicate == false) {
      state = state.copyWith(canEditProfile: true);
    }
  }

  /// 프로필 수정
  /// 마이페이지 - 프로필 수정
  Future<void> editProfile() async {
    if (currentUser == null) return;

    final uid = currentUser!.uid;

    try {
      state = state.copyWith(isUploading: true);

      /// 프로필이미지 업데이트
      if (state.temporaryImagePath != null) {
        await updateProfileImage();
      }

      /// 닉네임 업데이트
      if (state.nicknameInput != null) {
        await _repository.updateNickname(
          uid: uid,
          nickname: state.nicknameInput!,
        );
      }
      state = state.copyWith(isUploading: false);
    } catch (e) {
      log('프로필 업데이트 실패: $e');
    }
  }
}
