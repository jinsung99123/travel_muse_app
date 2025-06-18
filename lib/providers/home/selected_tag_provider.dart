import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 선택된 해시태그를 저장하는 상태 프로바이더
final selectedTagProvider = StateProvider<String?>((ref) => null);
