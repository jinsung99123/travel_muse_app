import 'package:flutter/material.dart';
import 'package:travel_muse_app/repositories/plan_repository.dart';
import 'package:travel_muse_app/repositories/schedule_repository.dart';
import 'package:travel_muse_app/services/place_search_service.dart';

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

  // Gemini 프롬프트 호출
  final aiPlan = await planRepo.getOptimizedPlanFromAI(
    days: days,
    region: region,
    typeCode: typeCode,
    context: context,
  );

  // 파싱 (기존 _parseAiPlan 로직과 동일)
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

  // Kakao API로 lat/lng/image enrich
  final enriched = <int, List<Map<String, String>>>{};

  for (final entry in parsed.entries) {
    final day = entry.key;
    final enrichedPlaces = <Map<String, String>>[];

    for (final place in entry.value) {
      final title = place['title']!;
      final description = place['description'] ?? '';

      final kakaoResults = await placeService.search('$region $title');
      final firstPlace = kakaoResults.isNotEmpty ? kakaoResults.first : null;

      final imageUrl = await placeService.fetchImageThumbnail('$region $title');

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

  await scheduleRepo.saveAiRoute(planId: planId, aiSchedules: enriched);

  onResult(enriched);
}
