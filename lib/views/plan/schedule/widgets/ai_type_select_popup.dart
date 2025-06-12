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
      title: const Text(
        'Ai 추천 받을 성향을 선택해주세요',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            _tests.map((test) {
              final isSelected = _selectedTest?.testId == test.testId;
              final type = test.result['type'];
              return ListTile(
                title: Text(
                  '성향: $type',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: Radio<String>(
                  value: test.testId,
                  groupValue: _selectedTest?.testId,
                  onChanged: (_) => setState(() => _selectedTest = test),
                  activeColor: Colors.lightBlueAccent,
                ),
              );
            }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('완료'),
        ),
      ],
    );
  }
}
