import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/post/post_write_page.dart';

class WriteFab extends StatelessWidget {
  const WriteFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PostWritePage()),
        );
      },
      label: const Text(
        '글쓰기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Pretendard',
        ),
      ),
      icon: const Icon(Icons.edit),
      backgroundColor: const Color(0xFF025ADF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
  }
}
