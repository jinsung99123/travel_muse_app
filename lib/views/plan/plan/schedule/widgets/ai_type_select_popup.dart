import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:travel_muse_app/models/preference/preference_test_model.dart';
import 'package:travel_muse_app/views/plan/plan/schedule/widgets/type_select_item.dart';

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Container(
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
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
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    _tests.map((test) {
                      final isSelected = _selectedTest?.testId == test.testId;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TypeSelectItem(
                          test: test,
                          isSelected: isSelected,
                          onTap: () => setState(() => _selectedTest = test),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 123,
                    height: 40,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF98A0A4)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            color: Color(0xFF34393B),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 123,
                    height: 40,
                    child: InkWell(
                      onTap:
                          _selectedTest == null
                              ? null
                              : () async {
                                await EasyLoading.show(
                                  status: 'AI 추천 일정을 생성 중입니다...',
                                );
                                try {
                                  final typeCode =
                                      _selectedTest!.result['type']!;
                                  await Future.delayed(
                                    const Duration(milliseconds: 500),
                                  );
                                  await widget.onComplete(typeCode);
                                } catch (e, s) {
                                  log(
                                    'onComplete error',
                                    error: e,
                                    stackTrace: s,
                                  );
                                } finally {
                                  await EasyLoading.dismiss();
                                  Navigator.pop(context);
                                }
                              },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF48CDFD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
