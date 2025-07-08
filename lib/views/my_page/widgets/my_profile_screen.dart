import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/user/profile_view_model_provider.dart';
import 'package:travel_muse_app/views/my_page/edit_profile_page.dart';

class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(profileViewModelProvider.notifier).fetchUserProfile();
    });
  }

  final Map<String, String> resultImageMap = {
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
    final fallbackImagePath = resultImageMap[profileState.fallbackTypeCode];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundImage:
                profileState.profileImageUrl != null
                    ? NetworkImage(profileState.profileImageUrl!)
                    : (fallbackImagePath != null
                        ? AssetImage(fallbackImagePath) as ImageProvider
                        : null),
            backgroundColor: AppColors.primary[100],
          ),
          const SizedBox(height: 15),
          Text(
            profileState.currentNickname ?? '',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 18,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
              if (result == true) {
                await ref
                    .read(profileViewModelProvider.notifier)
                    .fetchUserProfile();
              }
            },
            child: Container(
              width: 97,
              height: 40,
              decoration: ShapeDecoration(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: AppColors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Center(
                child: Text(
                  '프로필 수정',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
