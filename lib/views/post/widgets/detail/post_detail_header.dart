import 'package:flutter/material.dart';

class PostDetailHeader extends StatelessWidget {
  final String? nickname;
  final String? profileUrl;

  const PostDetailHeader({
    super.key,
    required this.nickname,
    required this.profileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFCED2D4),
          backgroundImage:
              (profileUrl?.isNotEmpty ?? false)
                  ? NetworkImage(profileUrl!)
                  : null,
          child:
              (profileUrl?.isEmpty ?? true)
                  ? const Text('프로필', style: TextStyle(fontSize: 12))
                  : null,
        ),
        const SizedBox(width: 12),
        Text(
          nickname ?? '닉네임',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
