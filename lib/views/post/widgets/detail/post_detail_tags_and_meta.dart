import 'package:flutter/material.dart';

class PostDetailTagsAndMeta extends StatelessWidget {
  const PostDetailTagsAndMeta({
    super.key,
    required this.tags,
    required this.createdAt,
    required this.viewCount,
  });
  final List<String> tags;
  final DateTime createdAt;
  final int viewCount;

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
        Text(
          '${createdAt.year}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.day.toString().padLeft(2, '0')} 작성   조회수 $viewCount',
          style: const TextStyle(color: Color(0xFF9CA1A4), fontSize: 13),
        ),
      ],
    );
  }
}
