import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/utills/region_data.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/widgets/district_box_list.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/widgets/save_button.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class DistrictSettingPage extends ConsumerStatefulWidget {
  const DistrictSettingPage({super.key, required this.selectedProvince});
  final String selectedProvince;

  @override
  DistrictSettingPageState createState() => DistrictSettingPageState();
}

class DistrictSettingPageState extends ConsumerState<DistrictSettingPage> {
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
      appBar: CustomAppBar(title: '여행 일정 등록'),
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
                  selectedIndices: selectedIndex != null ? {selectedIndex!} : {},
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              SaveButton(
                selectedIndex: selectedIndex,
                districts: districts,
                selectedProvince: widget.selectedProvince,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
