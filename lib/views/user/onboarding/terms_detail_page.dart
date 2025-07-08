import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:travel_muse_app/constants/markdown_style_sheet.dart';
import 'package:travel_muse_app/models/user/terms_model.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class TermsDetailPage extends StatelessWidget {
  const TermsDetailPage({super.key, required this.term});

  final Terms term;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(term.title),
        leading:
            Navigator.canPop(context)
                ? const CustomBackButton()
                : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  Markdown(
                    data: term.content,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    softLineBreak: true,
                    styleSheet: markdownStyle,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
