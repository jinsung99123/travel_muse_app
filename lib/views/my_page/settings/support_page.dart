import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: '고객 지원'), body: Text('고객 지원'));
  }
}
