import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/repositories/plan/plan_repository.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/ai_type_select_popup.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/ground_circle_icon.dart';

class AiButton extends StatelessWidget {
  const AiButton({
    super.key,
    required this.planId,
    required this.days,
    required this.region,
    required this.onResult,
  });

  final String planId;
  final int days;
  final String region;
  final void Function(Map<int, List<Map<String, String>>>) onResult;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog(
          context: context,
          builder:
              (_) => AiTypeSelectPopup(
                onComplete: (selectedTest) async {
                  final typeCode = selectedTest;
                  final planRepo = PlanRepository();
                  final placeService = PlaceSearchService();

                  final aiPlan = await planRepo.getOptimizedPlanFromAI(
                    days: days,
                    region: region,
                    typeCode: typeCode,
                    context: context,
                  );

                  final parsed = _parseAiPlan(aiPlan);

                  final enriched = <int, List<Map<String, String>>>{};
                  for (final entry in parsed.entries) {
                    final day = entry.key;
                    final enrichedPlaces = <Map<String, String>>[];

                    for (final place in entry.value) {
                      final title = place['title']!;
                      final description = place['description'] ?? '';

                      final kakaoResults = await placeService.search(
                        '$region $title',
                      );
                      final firstPlace =
                          kakaoResults.isNotEmpty ? kakaoResults.first : null;
                      final imageUrl = await placeService.fetchImageThumbnail(
                        '$region $title',
                      );

                      enrichedPlaces.add({
                        'title': title,
                        'description': description,
                        'lat': '${firstPlace?.latitude ?? 0.0}',
                        'lng': '${firstPlace?.longitude ?? 0.0}',
                        'image': imageUrl ?? '',
                        'subtitle':
                            firstPlace != null
                                ? '${firstPlace.city} ${firstPlace.district} • ${firstPlace.category}'
                                : '',
                      });
                    }

                    enriched[day] = enrichedPlaces;
                  }

                  // Firestore 저장 없이 UI 상태만 전달 (미리보기용)
                  onResult(enriched);
                },
              ),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      label: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary[50]!, AppColors.primary[300]!, AppColors.primary[400]!],
            stops: [0.0,0.3,0.7],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(28)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            GradientCircleIcon(size: 20),
            SizedBox(width: 8),
            Text(
              'Ai 추천 받기',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, List<Map<String, String>>> _parseAiPlan(String result) {
    final lines = result.split('\n');
    final Map<int, List<Map<String, String>>> parsed = {};
    int? currentDay;

    for (var line in lines) {
      if (line.startsWith('Day')) {
        final dayMatch = RegExp(r'Day (\d+)').firstMatch(line);
        if (dayMatch != null) {
          currentDay = int.parse(dayMatch.group(1)!);
          parsed[currentDay - 1] = [];
        }
      } else if (currentDay != null && line.trim().startsWith('-')) {
        final parts = line.replaceFirst('- ', '').split(':');
        final title = parts[0].trim();
        final description = parts.length > 1 ? parts[1].trim() : '';
        parsed[currentDay - 1]!.add({
          'title': title,
          'description': description,
        });
      }
    }
    return parsed;
  }
}
