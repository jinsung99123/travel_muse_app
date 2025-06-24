import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';

class SearchInputField extends StatefulWidget {
  const SearchInputField({
    super.key,
    required this.onSearch,
    this.hintText = '장소를 검색해보세요',
  });
  final ValueChanged<String> onSearch;
  final String hintText;

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  final TextEditingController _controller = TextEditingController();
  String _searchText = '';

  void _handleSearch() {
    if (_searchText.trim().isNotEmpty) {
      widget.onSearch(_searchText.trim());
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) => setState(() => _searchText = value),
          onSubmitted: (_) => _handleSearch(),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(CupertinoIcons.search),
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.grey[400],
              fontSize: 15,
              fontFamily: 'Pretendard',
            ),
            suffixIcon:
                _searchText.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.clear, color: AppColors.grey[400]),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _searchText = '');
                      },
                    )
                    : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}
