import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/calendar_locaion_provider.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/district_box_list.dart';

import 'package:travel_muse_app/views/plan/schedule/schedule_page.dart';

class DistrictSettingPage extends ConsumerStatefulWidget {
  final String selectedProvince;

  const DistrictSettingPage({super.key, required this.selectedProvince});

  @override
  _DistrictSettingPageState createState() => _DistrictSettingPageState();
}

class _DistrictSettingPageState extends ConsumerState<DistrictSettingPage> {
  late List<String> districts;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // 예시: 선택된 시/도에 따른 시/군/구 리스트 분기 처리
    switch (widget.selectedProvince) {
      case '서울':
        districts = ['강남구', '서초구', '송파구', '마포구', '용산구'];
        break;
      case '부산':
        districts = ['해운대구', '수영구', '동래구', '부산진구'];
        break;
      // 기타 지역 추가
      default:
        districts = ['지역 없음'];
    }
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
                            final viewModel = ref.read(
                              calendarLocationViewModelProvider.notifier,
                            );
                            // 시/도 + 시/군/구 조합 저장
                            viewModel.setRegion(
                              '${widget.selectedProvince} ${selectedDistrict}',
                            );

                            // 저장 처리
                            try {
                              await viewModel.savePlan('your_plan_id_here');
                              if (context.mounted) {
                                await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const SchedulePage(
                                          userId: '',
                                          planId: '',
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
