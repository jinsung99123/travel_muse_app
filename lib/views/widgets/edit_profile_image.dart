import 'package:flutter/material.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({
    super.key,
    required this.widgetSize,
    required this.iconSize,
  });
  final double widgetSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 이미지피커
      },
      child: SizedBox(
        width: widgetSize,
        height: widgetSize,
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1 / 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                // 추후 파이어베이스 이미지 url연결
                child: Image.network(
                  'https://picsum.photos/id/1/300/400',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomRight,
            //   child: Container(
            //     width: iconSize,
            //     height: iconSize,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(50),
            //       color: Colors.grey[200],
            //       border: Border.all(width: 1, color: Colors.grey[400]!),
            //     ),
            //     child: Icon(
            //       Icons.camera_alt,
            //       color: Colors.grey[600],
            //       size: 28,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
