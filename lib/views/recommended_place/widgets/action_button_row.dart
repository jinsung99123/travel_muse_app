import 'package:flutter/material.dart';

class ActionButtonRow extends StatelessWidget {
  const ActionButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _IconTextButton(icon: Icons.bookmark_border, label: '저장'),
        _IconTextButton(icon: Icons.calendar_today, label: '일정추가'),
        _IconTextButton(icon: Icons.reviews, label: '리뷰쓰기'),
        _IconTextButton(icon: Icons.share, label: '공유'),
      ],
    );
  }
}

class _IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _IconTextButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[800]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
