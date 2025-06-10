import 'package:flutter/material.dart';

class ProvinceBoxItem extends StatelessWidget {
  const ProvinceBoxItem({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.white,
          border: Border.all(
            color:
                isSelected
                    ? Colors.blue
                    : const Color.fromARGB(255, 238, 238, 238),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.blue.shade700 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
