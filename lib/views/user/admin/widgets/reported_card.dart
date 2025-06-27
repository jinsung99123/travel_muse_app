import 'package:flutter/material.dart';

class ReportedCard extends StatelessWidget {
  const ReportedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onDelete,
    required this.onClear,
    this.onShowReasons,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onClear;
  final VoidCallback? onShowReasons; 


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
            else if (value == 'clear') onClear();
            else if (value == 'reasons' && onShowReasons != null) onShowReasons!();
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'delete', child: Text('삭제')),
            const PopupMenuItem(value: 'clear', child: Text('신고 해제')),
            const PopupMenuItem(value: 'reasons', child: Text('신고 사유 보기')),
          ],
        ),
      ),
    );
  }
}
