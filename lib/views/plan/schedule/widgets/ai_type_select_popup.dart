import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:travel_muse_app/models/preference_test_model.dart';
import 'package:travel_muse_app/views/plan/schedule/widgets/type_select_item.dart';

class AiTypeSelectPopup extends StatefulWidget {
  const AiTypeSelectPopup({super.key, required this.onComplete});
  final Future<void> Function(String typeCode) onComplete;

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
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Center(
                    child: Text(
                      'Ai 추천 받을 성향을 선택해주세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF26272A),
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
                        return TypeSelectItem(
                          test: test,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedTest = test),
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
                              : () async {
                                EasyLoading.show(
                                  status: 'AI 추천 일정을 생성 중입니다...',
                                );
                                try {
                                  final typeCode =
                                      _selectedTest!.result['type']!;
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  ); // 실제 async 함수라면 제거
                                  await widget.onComplete(typeCode);
                                } catch (e, s) {
                                  log(
                                    'onComplete error',
                                    error: e,
                                    stackTrace: s,
                                    name: 'AiTypeSelectPopup',
                                    level: 1000,
                                  );
                                } finally {
                                  EasyLoading.dismiss(); // 인디케이터 닫기
                                  Navigator.pop(context); // 팝업 닫기
                                }
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
        ),
      ),
    );
  }
}
