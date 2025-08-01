import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/search_bar_widget.dart';

class PostSearchBar extends StatelessWidget {
  const PostSearchBar({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(hintText: '제목 또는 내용 검색', onChanged: onChanged);
  }
}
