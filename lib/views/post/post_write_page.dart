import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/post/widgets/image_preview_list.dart';
import 'package:travel_muse_app/views/post/widgets/post_action_buttons.dart';
import 'package:travel_muse_app/views/post/widgets/post_location_category.dart';
import 'package:travel_muse_app/views/post/widgets/post_text_fields.dart';

class PostWritePage extends StatefulWidget {
  const PostWritePage({super.key});

  @override
  State<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends State<PostWritePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '게시물 작성',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1F20),
            fontFamily: 'Pretendard',
            height: 1.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 입력 필드 + 기능 영역
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    PostTextFields(
                      titleController: titleController,
                      contentController: contentController,
                    ),
                    const SizedBox(height: 16),
                    const PostLocationCategory(),
                    const SizedBox(height: 16),
                    if (imagePaths.isNotEmpty)
                      ImagePreviewList(
                        imagePaths: imagePaths,
                        onRemove: (index) {
                          setState(() {
                            imagePaths.removeAt(index);
                          });
                        },
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // 하단 사진 추가 & 완료 버튼
            PostActionButtons(
              onPickImages: () {
                // TODO: 이미지 추가 구현
              },
              onSubmit: () {
                // TODO: 제출 버튼 구현
              },
            ),
          ],
        ),
      ),
    );
  }
}
