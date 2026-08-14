import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../providers/auth_providers.dart';
import '../providers/debug_provider.dart';
import '../providers/statistics_provider.dart';
import '../providers/users_provider.dart';
import '../router/central_routing.dart' show rootScaffoldMessengerKey;
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/debug_item.dart';
import 'loading_page.dart';

/// Page with debug utilities
class DebugUtilities extends ConsumerStatefulWidget {
  const DebugUtilities({super.key});

  @override
  ConsumerState<DebugUtilities> createState() => _DebugUtilitiesState();
}

class _DebugUtilitiesState extends ConsumerState<DebugUtilities> {
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final debugState = ref.watch(debugProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const MyAppBar(
          style: MyAppBarStyle.backButtonTitleCentered,
          title: 'Debug utilities',
        ),
        body: Background(
          child: CustomScrollView(
            slivers: [
              const SliverPadding(padding: EdgeInsets.only(top: 20)),

              // APP FLOW SECTION
              _buildSectionHeader('App Flow'),
              SliverList(
                delegate: SliverChildListDelegate([
                  DebugItem(
                    title: 'Reset "Has Opened Before"',
                    subtitle: 'Current: ${appState.hasOpenedBefore}',
                    icon: Icons.refresh_rounded,
                    buttonText: 'Reset',
                    onPressed: () {
                      ref.read(appStateProvider.notifier).setHasOpenedBefore(false);
                      _showDone(context, 'Reset successful. Restart app to see onboarding.');
                    },
                  ),
                  DebugItem(
                    title: 'Toggle "Session Initialized"',
                    subtitle: 'Current: ${appState.sessionInitialized}',
                    icon: Icons.bolt_rounded,
                    buttonText: 'Toggle',
                    onPressed: () {
                      final newVal = !appState.sessionInitialized;
                      ref.read(appStateProvider.notifier).setSessionInitialized(newVal);
                      _showDone(context, 'Session state toggled to $newVal.');
                    },
                  ),
                  DebugItem(
                    title: 'Clear Shooting Hand',
                    subtitle: 'Set to empty & uninitialize session',
                    icon: Icons.front_hand_rounded,
                    buttonText: 'Clear',
                    onPressed: () async {
                      final userId = ref.read(authUserProvider)?.id;
                      if (userId != null) {
                        try {
                          await ref.read(usersRepositoryProvider).updateShootingHand(
                                userId: userId,
                                shootingHand: null,
                              );

                          // First reset flag, THEN invalidate data to trigger logic
                          ref.read(appStateProvider.notifier).setSessionInitialized(false);
                          ref.invalidate(appUserProvider);

                          if (context.mounted) _showDone(context, 'Hand cleared. Returning Home will trigger prompt.');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  DebugItem(
                    title: 'Clear Activity History',
                    subtitle: 'Wipe all past basketball sessions',
                    icon: Icons.delete_sweep_rounded,
                    buttonText: 'Clear',
                    onPressed: () async {
                      final userId = ref.read(authUserProvider)?.id;
                      if (userId != null) {
                        try {
                          await ref.read(statisticsRepositoryProvider).clearStatistics(userId);
                          ref.invalidate(userStatisticsProvider);
                          if (context.mounted) _showDone(context, 'Activity history cleared successfully.');
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  DebugItem(
                    title: 'Disable Developer Mode',
                    subtitle: 'Hide this menu from settings',
                    icon: Icons.lock_open_rounded,
                    buttonText: 'Disable',
                    onPressed: () {
                      ref.read(debugProvider.notifier).setDeveloperMode(false);
                      context.pop(); // Go back to settings immediately

                      rootScaffoldMessengerKey.currentState?.clearSnackBars();
                      rootScaffoldMessengerKey.currentState?.showSnackBar(
                        const SnackBar(
                          content: Text('Developer mode disabled.'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(bottom: 120, left: 20, right: 20),
                        ),
                      );
                    },
                  ),
                ]),
              ),

              // NAVIGATION SECTION
              _buildSectionHeader('Navigation'),
              SliverList(
                delegate: SliverChildListDelegate([
                  DebugItem(
                    title: 'Test Results Page',
                    subtitle: 'Launch results with default JSON',
                    icon: Icons.analytics_rounded,
                    buttonText: 'Test',
                    onPressed: () {
                      final defaultJson = jsonDecode(kDefaultResultsJson);
                      context.go('/results', extra: defaultJson);
                    },
                  ),
                  DebugItem(
                    title: 'Test Loading Page',
                    subtitle: 'Show the analysis loading screen',
                    icon: Icons.hourglass_empty_rounded,
                    buttonText: 'Test',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) => const LoadingPage()),
                      );
                    },
                  ),
                ]),
              ),

              // SYSTEM SECTION
              _buildSectionHeader('System'),
              SliverList(
                delegate: SliverChildListDelegate([
                  DebugItem(
                    title: 'Performance Overlay',
                    subtitle: 'Show GPU and UI thread graphs',
                    icon: Icons.speed_rounded,
                    buttonText: debugState.showPerformanceOverlay ? 'Hide' : 'Show',
                    onPressed: () {
                      ref.read(debugProvider.notifier).togglePerformanceOverlay();
                    },
                  ),
                ]),
              ),
              _buildEnvironmentCard(),

              const SliverPadding(padding: EdgeInsets.only(bottom: 44)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 24, 16, 8),
        child: Text(
          title.toUpperCase(),
          style: AppTextStyles.labelSmall(
            context,
            color: AppThemeManager.primaryText.withValues(alpha: 0.5),
          ).copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppThemeManager.primaryText.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppThemeManager.primaryText.withValues(alpha: 0.05)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 16, color: AppThemeManager.secondaryText),
                  const SizedBox(width: 8),
                  Text('Environment Info', style: AppTextStyles.titleSmall(context)),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow('Supabase', supabaseDomain),
              _buildInfoRow('HF Space', hfSpace),
              _buildInfoRow('Version', '0.0.1 (Debug)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall(context, color: AppThemeManager.secondaryText)),
          Text(value, style: AppTextStyles.bodySmall(context, color: AppThemeManager.primaryText)),
        ],
      ),
    );
  }

  void _showDone(BuildContext context, String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: AppThemeManager.primaryText)),
        duration: const Duration(seconds: 3),
        backgroundColor: AppThemeManager.primaryBackground,
      ),
    );
  }
}
