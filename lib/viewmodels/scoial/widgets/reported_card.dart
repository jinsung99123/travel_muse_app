import 'package:flutter/material.dart';

class ReportedCard extends StatelessWidget {
  const ReportedCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onDelete,
    required this.onClear,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onDelete;
  final VoidCallback onClear;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(title, overflow: TextOverflow.ellipsis, softWrap: true),
        subtitle: Text(subtitle, softWrap: true),
        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onDelete != null)
                IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
              IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
            ],
          ),
        ),
      ),
    );
  }
}
