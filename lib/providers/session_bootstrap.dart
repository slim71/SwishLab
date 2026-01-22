import 'package:SwishLab/app.dart' show rootNavigatorKey;
import 'package:SwishLab/providers/users_provider.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Helper provider to feed the BuildContext
final navigationContextProvider = StateProvider<BuildContext?>((ref) => null);

final sessionBootstrapProvider = Provider<void>((ref) {
  final appState = ref.read(appStateProvider);
  final userAsync = ref.watch(appUserProvider);

  userAsync.whenData((user) {
    if (user == null) return;

    // Only run if session not yet initialized
    if (appState.sessionInitialized) return;

    // Show dialog AFTER build frame
    if (user.shootingHand?.isEmpty ?? true) {
      Future.microtask(() async {
        // You can pass BuildContext via ref if you wrap this in a widget
        final context = ref.read(navigationContextProvider);
        if (context != null) {
          await _showInfoDialog(
            'One quick step before you continue: tell us your shooting hand.',
          );
        }

        // Navigate after the dialog is closed
        // _rootNavigatorKey.currentState?.pushNamed(UserDataWidget.routeName);
      });
    }

    // Mark session initialized
    ref.read(appStateProvider.notifier).setSessionInitialized(true);
  });
});

// Helper function to show a custom dialog
Future<void> _showInfoDialog(String msg) async {
  final context = rootNavigatorKey.currentContext;
  if (context == null) return; // safety

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Info needed'),
      content: Text(msg, style: AppTextStyles.bodyLarge(color: Colors.black)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}