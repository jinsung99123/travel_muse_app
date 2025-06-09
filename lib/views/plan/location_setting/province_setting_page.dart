import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/district_setting_page.dart';
import 'package:travel_muse_app/views/plan/location_setting/widgets/province_box_list.dart';

class ProvinceSettingPage extends StatefulWidget {
  const ProvinceSettingPage({super.key});

  @override
  _ProvinceSettingPageState createState() => _ProvinceSettingPageState();
}

class _ProvinceSettingPageState extends State<ProvinceSettingPage> {
  final List<String> items = [
    '서울',
    '부산',
    '대구',
    '인천',
    '광주',
    '대전',
    '울산',
    '세종',
    '경기',
    '강원',
    '충북',
    '충남',
    '전북',
    '전남',
    '경북',
    '경남',
    '제주',
  ];
  final Set<int> selectedIndices = {};

  void onItemTap(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('여행할 지역을 선택해주세요')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ProvinceBoxList(
                  items: items,
                  selectedIndices: selectedIndices,
                  onTap: onItemTap,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DistrictSettingPage()),
                    );
                  },
                  child: Text(
                    '다음',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
