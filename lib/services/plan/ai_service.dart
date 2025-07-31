import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:travel_muse_app/utills/logger_util.dart';

class AiService {
  final _model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.0-flash',
  );

  int _callCount = 0;
  DateTime _lastReset = DateTime.now();

  /// 현재 1분 내 호출 횟수 제한 검사
  bool _canCall() {
    final now = DateTime.now();
    if (now.difference(_lastReset).inMinutes >= 1) {
      _lastReset = now;
      _callCount = 0;
    }
    return _callCount < 5;
  }

  /// 호출 횟수 1 증가
  void _recordCall() {
    _callCount += 1;
  }

  /// 성향 테스트에서 타입코드 추론 요청
  Future<String> getTypeCodeFromAI(String prompt, BuildContext context) async {
    try {
      if (!_canCall()) {
        logger.w('AI 호출 제한 초과됨');
        _showToast('AI 호출량이 너무 많습니다. 잠시 후 시도해주세요.');
        return '';
      }

      _recordCall();
      final result = await _model.generateContent([Content.text(prompt)]);
      return result.text?.trim() ?? '';
    } catch (e) {
      final errorMessage = _parseError(e);
      logger.e('AI 호출 실패 (getTypeCodeFromAI)', error: e);
      _showToast(errorMessage);
      return '';
    }
  }

  /// 일반적인 텍스트 생성 요청
  Future<String> generate(String prompt, BuildContext context) async {
    try {
      if (!_canCall()) {
        logger.w('AI 호출 제한 초과됨');
        _showToast('AI 호출량이 너무 많습니다. 잠시 후 시도해주세요.');
        return '';
      }

      _recordCall();
      final result = await _model.generateContent([Content.text(prompt)]);
      return result.text?.trim() ?? '';
    } catch (e) {
      final errorMessage = _parseError(e);
      logger.e('AI 호출 실패 (generate)', error: e);
      _showToast(errorMessage);
      return '';
    }
  }

  /// FirebaseAI 에러 응답을 사용자 친화적으로 변환
  String _parseError(dynamic error) {
    if (error.toString().contains('resource-exhausted')) {
      return 'AI 호출량이 초과되었습니다. 잠시 후 다시 시도해주세요.';
    }
    return 'AI 호출 중 문제가 발생했습니다.';
  }

  /// 사용자에게 토스트 메시지 표시
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 16.0,
    );
  }
}
