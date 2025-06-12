import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';

class TypeSelectItem extends StatelessWidget {
  const TypeSelectItem({
    super.key,
    required this.test,
    required this.isSelected,
    required this.onTap,
  });
  final PreferenceTest test;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = test.result['type'];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF15BFFD) : const Color(0xFFCED2D3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF15BFFD)
                        : const Color(0xFFCED2D3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                '성향: $type',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF26272A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
