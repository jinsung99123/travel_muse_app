import 'package:flutter/material.dart';

class SearchBarWithBackButton extends StatelessWidget {
  const SearchBarWithBackButton({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onSearch,
    required this.onSubmitted,
  });
  final TextEditingController controller;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final Function(String) onSubmitted;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: '장소 검색',
                border: InputBorder.none,
              ),
              onSubmitted: onSubmitted,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}