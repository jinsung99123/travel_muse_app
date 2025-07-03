import 'dart:async';

/// 입력 호출을 잠시 대기시켜
/// 같은 작업이 짧은 시간 안에 연속으로 실행되는 걸 막아준다
class Debouncer {
  Debouncer(this.delay);
  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();          // 직전 타이머 취소
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}
