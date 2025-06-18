import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/utills/region_data.dart';
import 'package:travel_muse_app/providers/plan/calendar_location_provider.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/district_setting_page.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/widgets/province_box_list.dart';

class ProvinceSettingPage extends ConsumerStatefulWidget {
  const ProvinceSettingPage({super.key});

  @override
  _ProvinceSettingPageState createState() => _ProvinceSettingPageState();
}

class _ProvinceSettingPageState extends ConsumerState<ProvinceSettingPage> {
  final List<String> items = provinces;

  final List<String> emojis = [
    '🏙️',
    '🌊',
    '🍂',
    '✈️',
    '🌳',
    '🏛️',
    '⚓',
    '🏰',
    '🏞️',
    '⛰️',
    '🏔️',
    '🌾',
    '🍚',
    '🌸',
    '🏯',
    '🚢',
    '🌴',
  ];

  int? selectedIndex;

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
                  '여행할 지역을 선택해주세요',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ProvinceBoxList(
                  items: items,
                  emojis: emojis,
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
                          : () {
                            final selectedRegion = items[selectedIndex!];
                            ref
                                .read(
                                  calendarLocationViewModelProvider.notifier,
                                )
                                .setRegion(selectedRegion);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => DistrictSettingPage(
                                      selectedProvince: selectedRegion,
                                    ),
                              ),
                            );
                          },
                  child: const Text(
                    '다음',
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
