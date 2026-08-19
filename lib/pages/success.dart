import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/users_row.dart';
import '../providers/users_provider.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/background.dart';
import '../widgets/custom_text_span.dart';
import '../widgets/dark_button.dart';

/// Page showing a confirmation of the account creation
class SuccessAfterSignup extends ConsumerStatefulWidget {
  const SuccessAfterSignup({super.key});

  @override
  ConsumerState<SuccessAfterSignup> createState() => _SuccessAfterSignupState();
}

class _SuccessAfterSignupState extends ConsumerState<SuccessAfterSignup> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;
    final userInfoAsync = ref.watch(appUserProvider);
    final UsersRow? userInfo = userInfoAsync.value;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppThemeManager.primaryBackground,
        body: Background(
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildGlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- CELEBRATORY ICON ---
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                          ).animate(onPlay: (c) => c.repeat()).scale(
                                duration: 2.seconds,
                                begin: const Offset(1, 1),
                                end: const Offset(1.4, 1.4),
                                curve: Curves.easeOut,
                              ).fade(begin: 0.3, end: 0.0),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.greenAccent.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ],
                      ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

                      const SizedBox(height: 32),

                      // --- SUCCESS TEXT ---
                      Text(
                        'Welcome to the Lab',
                        style: AppTextStyles.headlineMedium(context, color: AppThemeManager.primaryText).copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fade(delay: 200.ms).slideY(begin: 0.2),

                      const SizedBox(height: 12),

                      Text(
                        'Your account is ready.',
                        style: AppTextStyles.labelLarge(context, color: AppThemeManager.primaryText.withValues(alpha: 0.6)),
                      ).animate().fade(delay: 300.ms).slideY(begin: 0.2),

                      const SizedBox(height: 32),
                      Container(height: 1, color: Colors.white10),
                      const SizedBox(height: 32),

                      // --- USER INFO PILL ---
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppThemeManager.primaryText.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: AppThemeManager.primaryText.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.email_outlined, size: 16, color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                            const SizedBox(width: 8),
                            Text(
                              userInfo?.email ?? 'na@email.com',
                              style: AppTextStyles.bodyMedium(context, color: AppThemeManager.primaryText).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),

                      const SizedBox(height: 48),

                      RichText(
                        textAlign: TextAlign.center,
                        text: CustomTextSpan(
                          context,
                          style: AppTextStyles.bodySmall(context, color: AppThemeManager.primaryText.withValues(alpha: 0.5)),
                          children: [
                            CustomTextSpan(context, text: 'Tip: You can customize your shooting hand in '),
                            CustomTextSpan(
                              context,
                              text: 'Settings > User Info',
                              bold: true,
                              color: appColors.primaryOne,
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 600.ms),

                      const SizedBox(height: 32),

                      DarkButton(
                        onPressed: () => context.goNamed('getting-started'),
                        text: 'Get Started',
                      ).animate().fade(delay: 800.ms).slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
