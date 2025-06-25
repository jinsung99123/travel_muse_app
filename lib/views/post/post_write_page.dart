import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/utills/date_utils.dart';
import 'package:travel_muse_app/views/post/widgets/detail/place_preview_card.dart';
import 'package:travel_muse_app/views/post/widgets/write/image_preview_list.dart';
import 'package:travel_muse_app/views/post/widgets/write/post_action_buttons.dart';
import 'package:travel_muse_app/views/post/widgets/write/post_location_category.dart';
import 'package:travel_muse_app/views/post/widgets/write/post_text_fields.dart';

class PostWritePage extends ConsumerStatefulWidget {
  const PostWritePage({super.key, this.post});

  final Post? post;

  @override
  ConsumerState<PostWritePage> createState() => _PostWritePageState();
}

class _PostWritePageState extends ConsumerState<PostWritePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final List<String> imagePaths = [];
  Map<String, dynamic>? selectedPlace;

  Set<String> selectedTags = {};
  String? titleErrorText;
  String? contentErrorText;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      titleController.text = widget.post!.title;
      contentController.text = widget.post!.content;
      imagePaths.addAll(widget.post!.images);
      selectedTags = widget.post!.tags.toSet();
      selectedPlace = widget.post!.place;
    }
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isEmpty) return;

    final remaining = 5 - imagePaths.length;

    if (remaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지는 최대 5장까지만 업로드할 수 있어요.')),
      );
      return;
    }

    final addableFiles = pickedFiles.take(remaining).toList();

    setState(() {
      imagePaths.addAll(addableFiles.map((e) => e.path));
    });

    if (addableFiles.length < pickedFiles.length) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('최대 5장까지만 업로드할 수 있어요.')));
    }
  }

  void _submitPost() async {
    if (imagePaths.length > 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지는 최대 5장까지만 업로드할 수 있어요.')),
      );
      return;
    }
    final titleError = PostValidator.validateTitle(titleController.text);
    final contentError = PostValidator.validateContent(contentController.text);

    if (titleError != null || contentError != null) {
      setState(() {
        titleErrorText = titleError;
        contentErrorText = contentError;
      });
      return;
    }

    final notifier = ref.read(postViewModelProvider.notifier);

    await notifier.submitPost(
      existingPost: widget.post,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      imagePaths: imagePaths,
      tags: selectedTags.toList(),
      place: selectedPlace,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWritable =
        titleController.text.isNotEmpty || contentController.text.isNotEmpty;
    final postState = ref.watch(postViewModelProvider);
    final isLoading = postState is AsyncLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.post != null ? '게시물 수정' : '게시물 작성',
          style: const TextStyle(
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
                    if (selectedPlace != null) ...[
                      Stack(
                        children: [
                          PlacePreviewCard(
                            title: selectedPlace!['title'] ?? '',
                            address: selectedPlace!['address'] ?? '',
                            latLng: LatLng(
                              (selectedPlace!['lat'] as num).toDouble(),
                              (selectedPlace!['lng'] as num).toDouble(),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPlace = null;
                                });
                              },
                              child: const CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            PostLocationCategory(
              selectedTags: selectedTags,
              onTagsChanged: (tags) => setState(() => selectedTags = tags),
              selectedPlace: selectedPlace,
              onPlaceChanged: (place) => setState(() => selectedPlace = place),
            ),
            const SizedBox(height: 8),
            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 12),
              ImagePreviewList(
                imagePaths: imagePaths.take(5).toList(),
                onRemove: (index) => setState(() => imagePaths.removeAt(index)),
              ),
            ],
            const SizedBox(height: 8),
            PostActionButtons(
              onPickImages: pickImages,
              onSubmit: _submitPost,
              isWritable: isWritable,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
