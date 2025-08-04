import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/search_bar_widget.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.onSearch,
    this.hintText = '장소를 검색해보세요',
  });

  final ValueChanged<String> onSearch;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SearchBarWidget(
      hintText: hintText,
      onChanged: (text) {},
      onSubmitted: onSearch,
      backgroundColor: Colors.white,
    );
  }
}
