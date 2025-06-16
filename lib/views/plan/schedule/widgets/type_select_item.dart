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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF15BFFD)
                        : const Color(0xFFCED2D3),
                shape: BoxShape.circle,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: 8),
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
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
