import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class PostDetailHeader extends StatelessWidget {
  const PostDetailHeader({
    super.key,
    required this.nickname,
    required this.profileUrl,
  });
  final String? nickname;
  final String? profileUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.grey[100],
          backgroundImage:
              (profileUrl?.isNotEmpty ?? false)
                  ? NetworkImage(profileUrl!)
                  : null,
        ),
        const SizedBox(width: 12),
        Text(
          nickname ?? '닉네임',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
