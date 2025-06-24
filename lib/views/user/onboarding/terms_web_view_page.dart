import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsWebViewPage extends StatefulWidget {
  const TermsWebViewPage({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<TermsWebViewPage> createState() => _TermsWebViewPageState();
}

class _TermsWebViewPageState extends State<TermsWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: WebViewWidget(key: UniqueKey(), controller: _controller),
    );
  }
}
