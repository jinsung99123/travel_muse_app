import 'package:flutter/material.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({
    super.key,
    required this.imageUrls,
    required this.currentPage,
    required this.pageController,
    required this.onPageChanged,
  });

  final List<String> imageUrls;
  final int currentPage;
  final PageController pageController;
  final void Function(int) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: pageController,
            itemCount: imageUrls.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final url = imageUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: url.startsWith('http')
                    ? Image.network(url, fit: BoxFit.cover)
                    : Image.asset(url, fit: BoxFit.cover),
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
