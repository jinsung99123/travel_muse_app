import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/providers/preference_test_provider.dart';
import 'package:travel_muse_app/views/preference/widgets/result_view.dart';

class PreferenceLoadingPage extends ConsumerStatefulWidget {
  const PreferenceLoadingPage({
    super.key,
    required this.answers,
    required this.onRestart,
  });
  final List<Map<String, String>> answers;
  final VoidCallback onRestart;

  @override
  ConsumerState<PreferenceLoadingPage> createState() =>
      _PreferenceLoadingPageState();
}

class _PreferenceLoadingPageState extends ConsumerState<PreferenceLoadingPage> {
  bool _hasRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasRequested) {
      _hasRequested = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ref
            .read(preferenceTestViewModelProvider.notifier)
            .classifyTestOnly(widget.answers, context);

        if (mounted) {
          await Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_) => ResultView(onRestart: widget.onRestart),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '사용자님의 성향을 파악 중이에요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 292,
                height: 290,
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/loading.png',
                  width: 292,
                  height: 290,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
