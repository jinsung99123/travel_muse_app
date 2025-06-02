import 'package:flutter/material.dart';

class SchedulePlaceCard extends StatelessWidget {
  const SchedulePlaceCard({
    super.key,
    required this.place,
    required this.index,
    required this.showHandle,
  });
  final Map<String, String> place;
  final int index;
  final bool showHandle;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text('$index')),
        title: Text(place['title'] ?? ''),
        subtitle: Text(place['subtitle'] ?? ''),
        trailing: showHandle
            ? const Icon(Icons.drag_handle) // 편집 중에만 표시
            : null,
      ),
    );
  }
}
