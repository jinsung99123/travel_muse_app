import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';

class EditProfileImage extends ConsumerStatefulWidget {
  const EditProfileImage({super.key});

  @override
  ConsumerState<EditProfileImage> createState() => _EditProfileImageState();
}

class _EditProfileImageState extends ConsumerState<EditProfileImage> {
  bool _fetched = false;

  // 프로필이미지 최초 1회 가져오기
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetched) {
      ref.read(profileViewModelProvider.notifier).fetchProfileImageUrl();
      _fetched = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final imageUrlToShow =
        profileState.temporaryImagePath ??
        profileState.profileImageUrl; // 임시 저장 이미지가 없으면 기존 프로필 이미지 표시

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('프로필 사진', style: AppTextStyles.onboardingSectionTitle),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              await ref
                  .read(profileViewModelProvider.notifier)
                  .savePickedImageToLocal();
            },
            child: SizedBox(
              width: 88,
              height: 88,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color: AppColors.grey[200],
                  image:
                      imageUrlToShow != null
                          ? DecorationImage(
                            image:
                                profileState.temporaryImagePath == null
                                    ? NetworkImage(imageUrlToShow)
                                    : FileImage(File(imageUrlToShow))
                                        as ImageProvider,
                            fit: BoxFit.cover,
                          )
                          : null, // TODO: 기본 프로필 이미지 디자인 작업 완료 후 -> 기본 프로필 이미지 default로 표시
                ),
                child:
                    imageUrlToShow == null
                        ? Center(
                          child: SvgPicture.asset('assets/icons/camera.svg'),
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
