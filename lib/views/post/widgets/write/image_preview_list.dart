import 'dart:io';
import 'package:flutter/material.dart';

class ImagePreviewList extends StatelessWidget {
  const ImagePreviewList({
    super.key,
    required this.imagePaths,
    required this.onRemove,
  });

  final List<String> imagePaths;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final path = imagePaths[index];
          final isUrl = path.startsWith('http');

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    isUrl
                        ? Image.network(
                          path,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        )
                        : Image.file(
                          File(path),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onRemove(index),
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black87,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
