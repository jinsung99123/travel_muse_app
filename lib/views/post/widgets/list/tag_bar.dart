import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/constants/post_tags_list.dart';
import 'package:travel_muse_app/views/post/widgets/list/more_tag_button.dart';

class TagBar extends StatelessWidget {
  const TagBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = PostTagsList.allTags;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [TagButton(tags: tags), SizedBox(width: 10), MoreTagButton()],
      ),
    );
  }
}

class TagButton extends StatelessWidget {
  const TagButton({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 34,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder:
              (context, index) => Container(
                width: 72,
                height: 30,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: AppOtherStyles.unselectedTag,
                child: Center(
                  child: Text(tags[index], style: AppTextStyles.unselectedTag),
                ),
              ),
          separatorBuilder: (context, index) => SizedBox(width: 8),
          itemCount: tags.length,
        ),
      ),
    );
  }
}
