import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/region_data.dart';
import 'package:travel_muse_app/providers/calendar_location_provider.dart';
import 'package:travel_muse_app/providers/calendar_provider.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/district_box_list.dart';
import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

class DistrictSettingPage extends ConsumerStatefulWidget {
  const DistrictSettingPage({super.key, required this.selectedProvince});
  final String selectedProvince;

  @override
  _DistrictSettingPageState createState() => _DistrictSettingPageState();
}

class _DistrictSettingPageState extends ConsumerState<DistrictSettingPage> {
  late List<String> districts;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    districts = districtsByProvince[widget.selectedProvince] ?? ['지역 없음'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '여행 일정 등록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '세부 지역을 선택해주세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: DistrictBoxList(
                  items: districts,
                  selectedIndices:
                      selectedIndex != null ? {selectedIndex!} : {},
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedIndex == null ? Colors.grey : Colors.blue[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed:
                      selectedIndex == null
                          ? null
                          : () async {
                            final selectedDistrict = districts[selectedIndex!];

                            final calendarState = ref.read(
                              calendarViewModelProvider,
                            );
                            final locationViewModel = ref.read(
                              calendarLocationViewModelProvider.notifier,
                            );

                            locationViewModel.setRegion(
                              '${widget.selectedProvince} $selectedDistrict',
                            );

                            if (calendarState.startDay != null &&
                                calendarState.endDay != null) {
                              locationViewModel.setDateRange(
                                calendarState.startDay!,
                                calendarState.endDay!,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('날짜를 먼저 선택해주세요')),
                              );
                              return;
                            }

                            try {
                              final planId =
                                  await locationViewModel.createAndSavePlan();
                              if (context.mounted) {
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => SchedulePage(
                                          userId: '', // 필요 시 설정
                                          planId: planId,
                                        ),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('저장 중 오류가 발생했습니다: $e')),
                              );
                            }
                          },
                  child: const Text(
                    '저장',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
