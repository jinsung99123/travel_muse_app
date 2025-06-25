import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/post_tags_list.dart';
import 'package:travel_muse_app/views/post/widgets/write/category_chip.dart';

class BottomSheetCategory extends StatefulWidget {
  const BottomSheetCategory({
    super.key,
    required this.initialSelectedTags,
    required this.onChanged,
  });
  final Set<String> initialSelectedTags;
  final void Function(Set<String>) onChanged;

  @override
  State<BottomSheetCategory> createState() => _BottomSheetCategoryState();
}

class _BottomSheetCategoryState extends State<BottomSheetCategory> {
  final List<String> allTags = PostTagsList.allTags;

  late Set<String> selectedTags;

  @override
  void initState() {
    super.initState();
    selectedTags = {...widget.initialSelectedTags};
  }

  void _toggleTag(String tag) {
    setState(() {
      selectedTags.contains(tag)
          ? selectedTags.remove(tag)
          : selectedTags.add(tag);
    });

    widget.onChanged(selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.95,
      minChildSize: 0.25,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '카테고리 추가하기',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children:
                        allTags.map((tag) {
                          return CategoryChip(
                            label: tag,
                            isSelected: selectedTags.contains(tag),
                            onTap: () => _toggleTag(tag),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
