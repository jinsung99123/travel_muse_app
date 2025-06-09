import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/viewmodels/profile_view_model.dart';

class EditProfileImage extends ConsumerStatefulWidget {
  const EditProfileImage({super.key, required this.size});
  final double size;

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
    final profileViewModel = ref.read(profileViewModelProvider.notifier);
    final profileState = ref.watch(profileViewModelProvider);
    final imageUrlToShow =
        profileState.temporaryImageUrl ??
        profileState.profileImageUrl; // 임시 저장 이미지가 없으면 기존 프로필 이미지 표시

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프로필 사진',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              await profileViewModel.uploadProfileImage();
            },
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFB3B9BC),
                  borderRadius: BorderRadius.circular(500),
                ),
                child:
                    imageUrlToShow != null
                        ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500),
                            // image: DecorationImage(image: )
                          ),
                          child: Center(child: Text('이미지')),
                        )
                        : Center(
                          child: SvgPicture.asset('assets/icons/camera.svg'),
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
