import 'package:flutter/material.dart';

class VersionPage extends StatelessWidget {
  const VersionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('버전 정보')), body: Text('버전 정보'));
  }
}
