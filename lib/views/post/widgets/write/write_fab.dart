import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/views/post/post_write_page.dart';

class WriteFab extends ConsumerWidget {
  const WriteFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        // 글 작성 페이지로 이동하고 작성된 Post 객체를 받아옴
        final result = await Navigator.push<Post>(
          context,
          MaterialPageRoute(builder: (_) => const PostWritePage()),
        );

        // 작성된 Post가 있으면 바로 리스트에 추가
        if (result != null) {
          ref.read(postListViewModelProvider.notifier).addPost(result);
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF61A7FF), Color(0xFF025ADF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, color: Colors.white, size: 24),
            SizedBox(width: 4),
            Text(
              '글쓰기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
