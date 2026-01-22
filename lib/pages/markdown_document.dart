import 'package:SwishLab/functions/load_markdown.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';

class MarkdownDocument extends StatefulWidget {
  final String fileName;
  final String title;
  final String semanticsLabel;

  const MarkdownDocument({
    super.key,
    required this.fileName,
    required this.title,
    this.semanticsLabel = 'Document Markdown',
  });

  @override
  State<MarkdownDocument> createState() => _MarkdownDocumentState();
}

class _MarkdownDocumentState extends State<MarkdownDocument> {
  String _markdownSource = '# Loading...';

  @override
  void initState() {
    super.initState();
    _initMarkdown();
  }

  Future<void> _initMarkdown() async {
    final content = await loadMarkdown(widget.fileName);

    if (!mounted) return;

    setState(() {
      _markdownSource = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return Scaffold(
      backgroundColor: appColors.primaryBackground,
      appBar: MyAppBar(
        style: MyAppBarStyle.backButtonTitleCentered,
        title: widget.title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            label: widget.semanticsLabel,
            child: MarkdownWidget(
              markdown: Markdown.fromString(_markdownSource),
            ),
          ),
        ),
      ),
    );
  }
}
