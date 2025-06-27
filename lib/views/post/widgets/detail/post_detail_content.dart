import 'package:flutter/material.dart';

class PostDetailContent extends StatelessWidget {
  const PostDetailContent({
    super.key,
    required this.title,
    required this.content,
  });
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
      ],
    );
  }
}
