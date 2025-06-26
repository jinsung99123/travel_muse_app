import 'package:flutter/material.dart';

class PostDetailTagsAndMeta extends StatelessWidget {
  const PostDetailTagsAndMeta({
    super.key,
    required this.tags,
    required this.createdAt,
    required this.viewCount,
    required this.likeCount,
    required this.isLiked,
    required this.onLikePressed,
  });

  final List<String> tags;
  final DateTime createdAt;
  final int viewCount;
  final int likeCount;
  final bool isLiked;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children:
              tags
                  .map(
                    (tag) => Text(
                      tag.startsWith('#') ? tag : '#$tag',
                      style: const TextStyle(
                        color: Color(0xFF1672F3),
                        fontSize: 14,
                      ),
                    ),
                  )
                  .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')} 작성',
              style: const TextStyle(color: Color(0xFF9CA1A4), fontSize: 13),
            ),
            const SizedBox(width: 8),
            Text(
              '조회수 $viewCount',
              style: const TextStyle(color: Color(0xFF9CA1A4), fontSize: 13),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onLikePressed,
              child: Row(
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$likeCount',
                    style: const TextStyle(
                      color: Color(0xFF9CA1A4),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
