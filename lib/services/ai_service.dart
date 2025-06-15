import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AiService {
  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash',
  );

  int _callCount = 0;
  DateTime _lastReset = DateTime.now();

  bool _canCall() {
    final now = DateTime.now();
    if (now.difference(_lastReset).inMinutes >= 1) {
      _lastReset = now;
      _callCount = 0;
    }
    return _callCount < 5;
  }

  void _recordCall() {
    _callCount += 1;
  }

  Future<String> getTypeCodeFromAI(String prompt, BuildContext context) async {
    try {
      if (!_canCall()) {
        _showToast('AI 호출량이 너무 많습니다. 잠시 후 시도해주세요.');
        return '';
      }

      _recordCall();
      final result = await _model.generateContent([Content.text(prompt)]);
      return result.text?.trim() ?? '';
    } catch (e) {
      final errorMessage = _parseError(e);
      _showToast(errorMessage);
      return '';
    }
  }

  Future<String> generate(String prompt, BuildContext context) async {
    try {
      if (!_canCall()) {
        _showToast('AI 호출량이 너무 많습니다. 잠시 후 시도해주세요.');
        return '';
      }

      _recordCall();
      final result = await _model.generateContent([Content.text(prompt)]);
      return result.text?.trim() ?? '';
    } catch (e) {
      final errorMessage = _parseError(e);
      _showToast(errorMessage);
      return '';
    }
  }

  String _parseError(dynamic error) {
    if (error.toString().contains('resource-exhausted')) {
      return 'AI 호출량이 초과되었습니다. 잠시 후 다시 시도해주세요.';
    }
    return 'AI 호출 중 문제가 발생했습니다.';
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}
