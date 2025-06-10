import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    required this.placeData,
    this.isSelected = false,
    this.onTap, 
    super.key,
  });

  final Map<String, String> placeData;
  final bool isSelected;
  final VoidCallback? onTap; 

  @override
  Widget build(BuildContext context) {
    final name = placeData['title'] ?? '이름 없음';
    final address = placeData['subtitle'] ?? '주소 없음';
    final imageUrl = placeData['image'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isSelected ? 10 : 4,
        color: isSelected ? Colors.lightBlue[50] : Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(address, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
