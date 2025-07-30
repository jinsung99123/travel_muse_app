import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location/select_place_map_page.dart';
import 'package:travel_muse_app/views/post/widgets/write/bottom_sheet_category.dart';

class PostLocationCategory extends StatelessWidget {
  const PostLocationCategory({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.selectedPlace,
    required this.onPlaceChanged,
  });

  final Set<String> selectedTags;
  final ValueChanged<Set<String>> onTagsChanged;

  final Map<String, dynamic>? selectedPlace;
  final ValueChanged<Map<String, dynamic>>? onPlaceChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 위치
        GestureDetector(
          onTap: () async {
            final selectedPlace = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => const SelectPlaceMapPage(
                      planId: 'place-select-mode',
                      isSelectMode: true,
                    ),
              ),
            );

            if (selectedPlace != null &&
                selectedPlace is Map<String, dynamic>) {
              debugPrint('선택된 위치: ${selectedPlace['address']}');
              onPlaceChanged?.call(selectedPlace);
            }
          },
          child: buildItem(
            Icons.location_on_outlined,
            selectedPlace?['address'] ?? '위치 추가하기',
          ),
        ),

        // 카테고리
        GestureDetector(
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              builder:
                  (_) => BottomSheetCategory(
                    initialSelectedTags: selectedTags,
                    onChanged: onTagsChanged, // 실시간 반영
                  ),
            );
          },
          child: buildItem(
            Icons.tag,
            selectedTags.isEmpty
                ? '카테고리 추가하기'
                : selectedTags.map((e) => e.replaceAll('#', '')).join(', '),
          ),
        ),
      ],
    );
  }

  Widget buildItem(IconData icon, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: const Color(0xFF7C878C)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7C878C),
                fontFamily: 'Pretendard',
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF7C878C)),
        ],
      ),
    );
  }
}
