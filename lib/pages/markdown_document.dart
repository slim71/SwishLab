import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';

import '../functions/load_markdown.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';

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
    return Scaffold(
      backgroundColor: AppThemeManager.secondaryBackground,
      appBar: MyAppBar(
        style: MyAppBarStyle.backButtonTitleCentered,
        title: widget.title,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: MarkdownWidget(
            markdown: Markdown.fromString(_markdownSource),
            theme: MarkdownThemeData.mergeTheme(
              Theme.of(context),
              textStyle: TextStyle(
                color: AppThemeManager.primaryText,
                fontSize: 16,
              ),
              h1Style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppThemeManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
              h2Style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppThemeManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
              h3Style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppThemeManager.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
