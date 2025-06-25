import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  /// 관리자 권한 부여
  Future<void> giveAdminRole(String email) async {
    final callable = FirebaseFunctions.instance.httpsCallable('setAdminByEmail');
    try {
      final result = await callable.call({'email': email});
      print(result.data['message']);
    } catch (e) {
      print('오류 발생 (부여): $e');
      rethrow;
    }
  }

  /// 관리자 권한 박탈
  Future<void> revokeAdminRole(String email) async {
    final callable = FirebaseFunctions.instance.httpsCallable('revokeAdminByEmail');
    try {
      final result = await callable.call({'email': email});
      print(result.data['message']);
    } catch (e) {
      print('오류 발생 (박탈): $e');
      rethrow;
    }
  }
}
