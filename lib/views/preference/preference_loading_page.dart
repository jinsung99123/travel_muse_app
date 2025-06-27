import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/preference/preference_test_provider.dart';
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
            .read(preferenceTestStateNotifierProvider.notifier)
            .classifyTestOnly(widget.answers, context);

        if (mounted) {
          await Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder:
                  (_) => ResultView(
                    onRestart: widget.onRestart,
                    showButtons: true,
                    testId: '',
                  ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                '사용자님의 성향을 파악 중이에요',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const Spacer(),
              Center(
                child: SizedBox(
                  width: 292,
                  height: 290,

                  child: Image.asset(
                    'assets/gif/gif.gif',
                    width: 292,
                    height: 290,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
