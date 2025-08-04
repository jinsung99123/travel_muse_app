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
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  '카테고리 추가하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 15,
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
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 144,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
