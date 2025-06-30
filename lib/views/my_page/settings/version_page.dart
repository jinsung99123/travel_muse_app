import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: '버전 정보'), body: Text('버전 정보'));
  }
}
