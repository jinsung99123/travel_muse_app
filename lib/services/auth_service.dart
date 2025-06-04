import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Result<T> {
  // 데이터 or 실패 사유
  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  final T? data;
  final String? error;

  // 성공 여부
  bool get isSuccess => data != null;
}

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Future<Result<UserCredential>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return Result.failure('유저 취소');
      }

      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        return Result.failure('토큰 없음');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return Result.success(userCredential);
    } on SocketException {
      return Result.failure('네트워크 오류');
    } catch (_) {
      return Result.failure('알 수 없는 오류');
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
