import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/dynamic_asset.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppThemeManager.secondaryBackground,
        body: SafeArea(
          top: true,
          child:
              // Container with the content for the loading page
              Background(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child:
                  // Column to place the content for the loading page
                  Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Loading animation
                    const DynamicAsset(
                      name: 'loader_basketball.json',
                      type: 'animation',
                      width: 300,
                      height: 300,
                    ),

                    // "Processing Video" text
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 16, 32, 0),
                      child: Text(
                        'Loading',
                        style: AppTextStyles.headlineLarge(context, color: Colors.black),
                      ),
                    ),

                    // Text to ask the user to wait a bit
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(32, 8, 32, 0),
                      child: Text(
                        'Please wait...',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge(context, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
