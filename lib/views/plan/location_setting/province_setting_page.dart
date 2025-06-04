import 'package:flutter/material.dart';
import 'district_setting_page.dart';

class ProvinceSettingPage extends StatefulWidget {
  const ProvinceSettingPage({super.key});

  @override
  _ProvinceSettingPageState createState() => _ProvinceSettingPageState();
}

class _ProvinceSettingPageState extends State<ProvinceSettingPage> {
  final List<String> items = List.generate(9, (index) => '서울');
  final Set<int> selectedIndices = {}; // 선택된 아이템 인덱스 저장

  @override
  Widget build(BuildContext context) {
    double boxWidth = (MediaQuery.of(context).size.width - 48) / 3;

    return Scaffold(
      appBar: AppBar(title: Text('여행할 지역을 선택해주세요')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: List.generate(items.length, (index) {
                    bool isSelected = selectedIndices.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndices.remove(index);
                          } else {
                            selectedIndices.add(index);
                          }
                        });
                      },
                      child: Container(
                        width: boxWidth,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          items[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DistrictSettingPage()),
                    );
                  },
                  child: Text(
                    '다음 버튼',
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
