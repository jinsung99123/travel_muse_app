import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객 지원'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: Text('고객 지원'),
    );
  }
}
