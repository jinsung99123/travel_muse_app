import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class PostDetailHeader extends StatelessWidget {
  const PostDetailHeader({
    super.key,
    required this.nickname,
    required this.profileUrl,
    required this.fallbackTypeCode,
  });

  final String? nickname;
  final String? profileUrl;
  final String? fallbackTypeCode;

  static const Map<String, String> resultImageMap = {
    '계획러': 'assets/images/planner.png',
    '자유인': 'assets/images/free_spirit.png',
    '자연인': 'assets/images/nature_lover.png',
    '도시러': 'assets/images/city_explorer.png',
    '균형러': 'assets/images/balancer.png',
    '모험가': 'assets/images/adventurer.png',
  };

  @override
  Widget build(BuildContext context) {
    final fallbackAsset = resultImageMap[fallbackTypeCode?.trim() ?? ''];
    final hasNetworkImage = profileUrl?.isNotEmpty ?? false;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.grey[100],
          backgroundImage:
              hasNetworkImage
                  ? NetworkImage(profileUrl!)
                  : (fallbackAsset != null ? AssetImage(fallbackAsset) : null),
          child:
              (!hasNetworkImage && fallbackAsset == null)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
        ),

        const SizedBox(width: 12),
        Text(
          nickname ?? '',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
