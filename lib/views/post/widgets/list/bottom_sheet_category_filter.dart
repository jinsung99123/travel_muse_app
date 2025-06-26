import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/post_tags_list.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/views/post/widgets/write/category_chip.dart';

class BottomSheetCategoryFilter extends ConsumerStatefulWidget {
  const BottomSheetCategoryFilter({super.key});

  @override
  ConsumerState<BottomSheetCategoryFilter> createState() =>
      _BottomSheetCategoryFilterState();
}

class _BottomSheetCategoryFilterState extends ConsumerState<BottomSheetCategoryFilter> {
  final allTags = PostTagsList.allTags;

  String? selectedTag;

  @override
  void initState() {
    super.initState();
    final filter = ref
        .read(postListViewModelProvider)
        .maybeWhen(data: (data) => data.filter, orElse: () => null);

    selectedTag = filter;
  }

  void _toggleTag(String tag) {
    setState(() {
      selectedTag = tag;
    });

    ref.read(postListViewModelProvider.notifier).setFilterState(tag);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리 선택',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                allTags.map((tag) {
                  return CategoryChip(
                    label: tag,
                    isSelected: tag == selectedTag,
                    onTap: () => _toggleTag(tag),
                  );
                }).toList(),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
