import 'package:flutter/material.dart';

AppBar buildPostDetailAppBar(VoidCallback onMoreTap) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: const BackButton(color: Colors.black),
    actions: [
      IconButton(
        icon: const Icon(Icons.more_vert, color: Colors.black),
        onPressed: onMoreTap,
      ),
    ],
  );
}
