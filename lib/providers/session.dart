import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../logger.dart';
import '../models/user_row_data.dart';
import '../state/app_state.dart';
import 'supabase_provider.dart';
import 'users_provider.dart';

/// Handles one-time session initialization tasks for the current user
final sessionBootstrapProvider = Provider<void>((ref) {
  final userAsync = ref.watch(appUserProvider);
  final logger = AppLogger.scope('SessionBootstrap');

  userAsync.whenData((user) {
    if (user == null) return;

    // Sync user data to appState to keep UI fresh
    ref.read(appStateProvider.notifier).setUserData(UserRowData(
          userID: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          eMail: user.email,
          profilePicture: user.profilePic ?? kDefaultProfilePictureUrl,
          registrationDate: user.createdAt,
          shootingHand: user.shootingHand,
        ));

    logger.d('Data synced for ${user.email}. Shooting hand: ${user.shootingHand}');
  });
});

/// Tracks the current authentication status of the app
final verifiedSessionProvider = FutureProvider<Session?>((ref) async {
  final supabase = ref.read(supabaseProvider);
  return supabase.auth.currentSession;
});
