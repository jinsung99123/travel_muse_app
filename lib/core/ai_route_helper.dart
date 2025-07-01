import 'package:flutter/material.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/repositories/plan/plan_repository.dart';
import 'package:travel_muse_app/repositories/plan/schedule_repository.dart';
import 'package:travel_muse_app/services/plan/place_search_service.dart';

Future<void> generateAndSaveEnrichedAiRoute({
  required BuildContext context,
  required String planId,
  required int days,
  required String region,
  required String typeCode,
  required void Function(Map<int, List<Map<String, String>>>) onResult,
}) async {
  final planRepo = PlanRepository();
  final scheduleRepo = ScheduleRepository();
  final placeService = PlaceSearchService();

  // 여행일수 제한 (10일 초과 시 중단)
  if (days > 10) {
    CustomToast.show(context: context, message: '여행일정은 최대 10일까지 가능합니다.');
    return;
  }

  // Gemini 프롬프트 호출
  final aiPlan = await planRepo.getOptimizedPlanFromAI(
    days: days,
    region: region,
    typeCode: typeCode,
    context: context,
  );

  // 파싱
  final lines = aiPlan.split('\n');
  final parsed = <int, List<Map<String, String>>>{};
  int? currentDay;

  for (final line in lines) {
    if (line.startsWith('Day')) {
      final match = RegExp(r'Day (\d+)').firstMatch(line);
      if (match != null) {
        currentDay = int.parse(match.group(1)!);
        parsed[currentDay - 1] = [];
      }
    } else if (currentDay != null && line.trim().startsWith('-')) {
      final parts = line.replaceFirst('- ', '').split(':');
      final title = parts[0].trim();
      final description = parts.length > 1 ? parts[1].trim() : '';
      parsed[currentDay - 1]!.add({'title': title, 'description': description});
    }
  }

  // Kakao API로 lat/lng/image enrich (병렬 처리 적용)
  final enriched = <int, List<Map<String, String>>>{};

  for (final entry in parsed.entries) {
    final day = entry.key;
    final places = entry.value;

    // 각 장소 enrich 작업 병렬 처리
    final enrichedPlaces = await Future.wait(
      places.map((place) async {
        final title = place['title']!;
        final description = place['description'] ?? '';

        final kakaoResults = await placeService.search('$region $title');
        final firstPlace = kakaoResults.isNotEmpty ? kakaoResults.first : null;

        final imageUrl = await placeService.fetchImageThumbnail(
          '$region $title',
        );

        return {
          'title': title,
          'description': description,
          'lat': '${firstPlace?.latitude ?? 0.0}',
          'lng': '${firstPlace?.longitude ?? 0.0}',
          'image': imageUrl ?? '',
          'subtitle':
              firstPlace != null
                  ? '${firstPlace.city} ${firstPlace.district} • ${firstPlace.category}'
                  : '',
        };
      }).toList(),
    );

    enriched[day] = enrichedPlaces;
  }

  ///route만 저장으로 변경
  await scheduleRepo.saveDaySchedules(planId: planId, daySchedules: enriched);

  onResult(enriched);
}
