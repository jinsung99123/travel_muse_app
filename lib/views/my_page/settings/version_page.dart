import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('버전 정보'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: Text('버전 정보'),
    );
  }
}
