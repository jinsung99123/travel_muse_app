import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';

class AiTypeSelectPopup extends StatefulWidget {
  const AiTypeSelectPopup({super.key, required this.onComplete});
  final void Function(String typeCode) onComplete;

  @override
  State<AiTypeSelectPopup> createState() => _AiTypeSelectPopupState();
}

class _AiTypeSelectPopupState extends State<AiTypeSelectPopup> {
  List<PreferenceTest> _tests = [];
  PreferenceTest? _selectedTest;

  @override
  void initState() {
    super.initState();
    _fetchTests();
  }

  Future<void> _fetchTests() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query =
        await FirebaseFirestore.instance
            .collection('preference_test')
            .where('userId', isEqualTo: uid)
            .get();

    final tests =
        query.docs
            .map((doc) => PreferenceTest.fromDoc(doc.id, doc.data()))
            .toList();

    setState(() {
      _tests = tests;
      if (_tests.isNotEmpty) {
        _selectedTest = _tests.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Ai 추천 받을 성향을 선택해주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF26272A),
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  _tests.map((test) {
                    final isSelected = _selectedTest?.testId == test.testId;
                    final type = test.result['type'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTest = test),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:
                                isSelected
                                    ? const Color(0xFF15BFFD)
                                    : const Color(0xFFCED2D3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(12),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF15BFFD)
                                        : const Color(0xFFCED2D3),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              '성향: $type',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF26272A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Color(0xFF98A0A4)),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color(0xFF34393B),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _selectedTest == null
                          ? null
                          : () {
                            Navigator.pop(context);
                            final typeCode = _selectedTest!.result['type'];
                            widget.onComplete(typeCode!);
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48CDFD),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
