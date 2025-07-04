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
  // 프로필이미지 최초 1회 가져오기
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileViewModelProvider.notifier).fetchProfileImageUrl();
    });
  }

  final resultImageMap = {
    '계획러': 'assets/images/planner.png',
    '자유인': 'assets/images/free_spirit.png',
    '자연인': 'assets/images/nature_lover.png',
    '도시러': 'assets/images/city_explorer.png',
    '균형러': 'assets/images/balancer.png',
    '모험가': 'assets/images/adventurer.png',
  };
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    final fallbackAsset = resultImageMap[profileState.fallbackTypeCode];
    final imageUrlToShow =
        profileState.temporaryImagePath ?? profileState.profileImageUrl;

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
                  .savePickedImageToLocal(88);
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
                          : (fallbackAsset != null
                              ? DecorationImage(
                                image: AssetImage(fallbackAsset),
                                fit: BoxFit.cover,
                              )
                              : null),
                ),
                child:
                    (imageUrlToShow == null && fallbackAsset == null)
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
