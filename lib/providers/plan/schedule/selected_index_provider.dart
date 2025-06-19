import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 장소 선택 상태 관리
final selectedIndexProvider = StateNotifierProvider<SelectedIndexVM, Set<int>>(
  (ref) => SelectedIndexVM(),
);

class SelectedIndexVM extends StateNotifier<Set<int>> {
  SelectedIndexVM() : super({});

  void toggle(int index) {
    if (state.contains(index)) {
      // 복사본 만들어서 remove
      state = {...state}..remove(index);
    } else {
      // 새 값 추가
      state = {...state, index};
    }
  }

  void clear() => state = {};
}
