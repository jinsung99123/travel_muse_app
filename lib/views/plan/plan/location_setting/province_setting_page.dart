import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/utills/region_data.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/widgets/next_button.dart';
import 'package:travel_muse_app/views/plan/plan/location_setting/widgets/province_box_list.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class ProvinceSettingPage extends ConsumerStatefulWidget {
  const ProvinceSettingPage({super.key});

  @override
  ProvinceSettingPageState createState() => ProvinceSettingPageState();
}

class ProvinceSettingPageState extends ConsumerState<ProvinceSettingPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '여행 일정 등록'),
      // AppBar(
      //   title: Text(
      //     '여행 일정 등록',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.grey[800],
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
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
                  items: provinces,
                  emojis: emojis,
                  selectedIndices: selectedIndex != null ? {selectedIndex!} : {},
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              NextButton(selectedIndex: selectedIndex, provinces: provinces),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
