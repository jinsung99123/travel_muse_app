import 'package:flutter/material.dart';

class PostDetailImages extends StatelessWidget {
  const PostDetailImages({super.key, required this.images});
  final List<String> images;

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            // ignore: deprecated_member_use
            backgroundColor: Colors.black.withOpacity(0.9),
            insetPadding: EdgeInsets.zero,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: InteractiveViewer(
                child: Center(child: Image.network(imageUrl)),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      children:
          images.map((url) {
            return GestureDetector(
              onTap: () => _showFullImage(context, url),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    url,
                    fit: BoxFit.contain, // 원본 비율 유지
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }
}
