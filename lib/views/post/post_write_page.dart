import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_muse_app/utills/date_utils.dart';
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

  Set<String> selectedTags = {};
  String? selectedLocation;

  String? titleErrorText;
  String? contentErrorText;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        imagePaths.addAll(pickedFiles.map((e) => e.path));
      });
    }
  }

  void _submitPost() {
    final titleError = PostValidator.validateTitle(titleController.text);
    final contentError = PostValidator.validateContent(contentController.text);

    if (titleError != null || contentError != null) {
      setState(() {
        titleErrorText = titleError;
        contentErrorText = contentError;
      });
      return;
    }

    // TODO: 게시물 저장 로직 실행
  }

  @override
  Widget build(BuildContext context) {
    final isWritable =
        titleController.text.isNotEmpty || contentController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '게시물 작성',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1F20),
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
                      onChanged:
                          () => setState(() {
                            titleErrorText = null;
                            contentErrorText = null;
                          }),
                    ),
                    if (titleErrorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          titleErrorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    if (contentErrorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          contentErrorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            PostLocationCategory(
              selectedTags: selectedTags,
              onTagsChanged: (tags) => setState(() => selectedTags = tags),
            ),
            const SizedBox(height: 8),
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              ImagePreviewList(
                imagePaths: imagePaths,
                onRemove: (index) => setState(() => imagePaths.removeAt(index)),
              ),
            ],
            const SizedBox(height: 8),
            PostActionButtons(
              onPickImages: pickImages,
              onSubmit: _submitPost,
              isWritable: isWritable,
            ),
          ],
        ),
      ),
    );
  }
}
