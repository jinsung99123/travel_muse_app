import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/plan/location_setting/%08widgets/selectable_box_list.dart';

class DistrictSettingPage extends StatefulWidget {
  const DistrictSettingPage({super.key});

  @override
  _DistrictSettingPageState createState() => _DistrictSettingPageState();
}

class _DistrictSettingPageState extends State<DistrictSettingPage> {
  final List<String> items = List.generate(9, (index) => '마포');
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
              SelectableBoxList(
                items: items,
                selectedIndices: selectedIndices,
                onTap: onItemTap,
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 0),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
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
