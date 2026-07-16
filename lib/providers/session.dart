import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../logger.dart';
import '../models/user_row_data.dart';
import '../router/central_routing.dart' show rootNavigatorKey;
import '../state/app_state.dart';
import '../styles/styles.dart';
import 'supabase_provider.dart';
import 'users_provider.dart';

/// Helper provider to feed the BuildContext
final navigationContextProvider = StateProvider<BuildContext?>((ref) => null);

/// Handles one-time session initialization tasks for the current user
final sessionBootstrapProvider = Provider<void>((ref) {
  final userAsync = ref.watch(appUserProvider);

  userAsync.whenData((user) {
    if (user == null) return;

    // Only run if session not yet initialized
    final sessionInitialized = ref.read(appStateProvider).sessionInitialized;
    if (sessionInitialized) return;

    // Sync user data to appState
    ref.read(appStateProvider.notifier).setUserData(UserRowData(
          userID: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          eMail: user.email,
          profilePicture: user.profilePic ?? kDefaultProfilePictureUrl,
          registrationDate: user.createdAt,
          shootingHand: user.shootingHand,
        ));

    // Show dialog AFTER build frame
    if (user.shootingHand?.isEmpty ?? true) {
      Future.microtask(() async {
        await _showInfoDialog(
          'One quick step before you continue: tell us your shooting hand.',
        );
      });
    }

    // Mark session initialized
    ref.read(appStateProvider.notifier).setSessionInitialized(true);
  });
});

/// Helper function to show a custom dialog
Future<void> _showInfoDialog(String msg) async {
  final context = rootNavigatorKey.currentContext;
  final logger = AppLogger.scope('Shooting hand dialog');
  if (context == null) return; // safety

  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Info needed'),
      content: Text(msg, style: AppTextStyles.bodyLarge(context, color: Colors.black)),
      actions: [
        TextButton(
          onPressed: () async {
            logger.d('Navigating...');
            context.goNamed('user');
          },
          child: const Text('Ok'),
        ),
      ],
    ),
  );
}

/// Tracks the current authentication status of the app
final verifiedSessionProvider = FutureProvider<Session?>((ref) async {
  final supabase = ref.read(supabaseProvider);
  return supabase.auth.currentSession;
});
