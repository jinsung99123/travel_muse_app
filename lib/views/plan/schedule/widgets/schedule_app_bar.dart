import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/location/map_page.dart';

class ScheduleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ScheduleAppBar({
    super.key,
    required this.isEditing,
    required this.onToggleEdit,
  });
  final bool isEditing;
  final VoidCallback onToggleEdit;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('제주 여행', style: TextStyle(fontSize: 18)),
          Text('2025.6.27 - 6.29', style: TextStyle(fontSize: 14)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.map),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapPage(planId: 'test',)),
            );
          },
        ),
        IconButton(
          icon: Icon(isEditing ? Icons.check : Icons.edit),
          onPressed: onToggleEdit,
        ),
      ],
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 16);
}
