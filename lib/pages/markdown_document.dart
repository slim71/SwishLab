import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../router/central_routing.dart';
import '../functions/load_markdown.dart';
import '../router/app_documents.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';

class MarkdownDocument extends ConsumerStatefulWidget {
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
  ConsumerState<MarkdownDocument> createState() => _MarkdownDocumentState();
}

class _MarkdownDocumentState extends ConsumerState<MarkdownDocument> {
  String _markdownSource = '# Loading...';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initMarkdown();
  }

  Future<void> _initMarkdown() async {
    if (!mounted) return;
    final bundle = DefaultAssetBundle.of(context);
    final content = await loadMarkdown(widget.fileName, bundle: bundle);

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
              onLinkTap: (title, url) {
                if (url.startsWith('app://')) {
                  final target = url.replaceFirst('app://', '');
                  if (appDocuments.containsKey(target)) {
                    ref.read(routerProvider).pushNamed('document', pathParameters: {'name': target});
                  } else {
                    ref.read(routerProvider).pushNamed(target);
                  }
                } else if (appDocuments.containsKey(url)) {
                  ref.read(routerProvider).pushNamed('document', pathParameters: {'name': url});
                }
              },
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
