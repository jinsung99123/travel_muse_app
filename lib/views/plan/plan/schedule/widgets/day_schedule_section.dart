import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/bullet.dart';

class DayScheduleSection extends StatelessWidget {
  const DayScheduleSection({
    super.key,
    required this.dayIndex,
    required this.dayLabel,
    required this.isExpanded,
    required this.onToggle,
  });

  final int dayIndex;
  final String dayLabel;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13, top: 12, bottom: 4, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Bullet(),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                Text(
                  'Day ${dayIndex + 1}  $dayLabel',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onToggle,
                  child: Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
