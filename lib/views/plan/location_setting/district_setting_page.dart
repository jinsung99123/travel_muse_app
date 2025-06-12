import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/region_data.dart';
import 'package:travel_muse_app/providers/calendar_locaion_provider.dart';
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
