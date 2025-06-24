import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsWebViewPage extends StatelessWidget {
  const TermsWebViewPage({super.key, required this.title, required this.url});
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    final controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
