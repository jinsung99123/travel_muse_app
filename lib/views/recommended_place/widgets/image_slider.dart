import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;
  final int currentPage;
  final PageController pageController;
  final void Function(int) onPageChanged;

  const ImageSlider({
    super.key,
    required this.imageUrls,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: pageController,
            itemCount: imageUrls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imageUrls[index], fit: BoxFit.cover),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${currentPage + 1} / ${imageUrls.length}',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
