import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/constants/post_tags_list.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/views/post/widgets/list/more_tag_button.dart';

class TagBar extends ConsumerStatefulWidget {
  const TagBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagBarState();
}

class _TagBarState extends ConsumerState<TagBar> {
  @override
  Widget build(BuildContext context) {
    final allTags = PostTagsList.allTags;

    final selectedFilter = ref
        .watch(postListViewModelProvider)
        .maybeWhen(data: (data) => data.filter, orElse: () => null);

    final reorderedTags =
        (selectedFilter != null && allTags.contains(selectedFilter))
            ? [selectedFilter, ...allTags.where((tag) => tag != selectedFilter)]
            : allTags;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: reorderedTags.length,
                itemBuilder: (context, index) {
                  final tag = reorderedTags[index];
                  final isSelected = tag == selectedFilter;

                  return GestureDetector(
                    onTap: () {
                      final newFilter = isSelected ? null : tag;
                      ref
                          .read(postListViewModelProvider.notifier)
                          .setFilterState(newFilter);
                    },
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration:
                          tag == selectedFilter
                              ? AppOtherStyles.selectedTag
                              : AppOtherStyles.unselectedTag,
                      child: Center(
                        child: Text(
                          tag,
                          style:
                              tag == selectedFilter
                                  ? AppTextStyles.selectedTag
                                  : AppTextStyles.unselectedTag,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8),
              ),
            ),
          ),
          SizedBox(width: 10),
          MoreTagButton(),
        ],
      ),
    );
  }
}
