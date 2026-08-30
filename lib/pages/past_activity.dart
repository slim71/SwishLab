import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';

/// Page to show past user activity
class PastActivity extends ConsumerStatefulWidget {
  const PastActivity({super.key});

  @override
  ConsumerState<PastActivity> createState() => _PastActivityState();
}

class _PastActivityState extends ConsumerState<PastActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppThemeManager.primaryBackground,
      appBar: const MyAppBar(
        style: MyAppBarStyle.titleOnly,
        title: 'Past Activity',
      ),
      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Descriptive text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'All activity from this past month.',
                    style:
                        AppTextStyles.labelMedium(context, color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                  ),
                ),

                // Premium Placeholder Card
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/wip.png',
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Timeline coming soon',
                          style: AppTextStyles.titleLarge(context).copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We are working on a premium history experience for your shooting sessions.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall(context, color: AppThemeManager.secondaryText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
