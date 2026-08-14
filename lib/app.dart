import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/debug_provider.dart';
import 'providers/session.dart';
import 'providers/supabase_provider.dart';
import 'providers/users_provider.dart';
import 'router/central_routing.dart' show routerProvider, rootScaffoldMessengerKey;
import 'styles/theme_manager.dart';
import 'styles/themes.dart';

// Expose the app title globally through this one provider
final appTitleProvider = Provider((_) => 'SwishLab');

// Root widget of the app
class SwishLab extends ConsumerStatefulWidget {
  const SwishLab({super.key});

  @override
  ConsumerState<SwishLab> createState() => _SwishLabState();
}

class _SwishLabState extends ConsumerState<SwishLab> {
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final title = ref.watch(appTitleProvider);
    final debugState = ref.watch(debugProvider);
    ref.watch(supabaseAuthListenerProvider); // triggers creation
    ref.watch(sessionBootstrapProvider); // triggers shooting hand check

    // Map AppThemeManager.brightness to ThemeMode
    final themeMode = switch (AppThemeManager.brightness) {
      AppBrightness.system => ThemeMode.system,
      AppBrightness.light => ThemeMode.light,
      AppBrightness.dark => ThemeMode.dark,
    };

    // Listener to add the user to the DB
    ref.listen<AsyncValue<Session?>>(
      verifiedSessionProvider,
      (previous, next) {
        next.when(
          data: (session) async {
            if (session == null) return;

            try {
              final usersRepo = ref.read(usersRepositoryProvider);
              final existing = await usersRepo.getUserRow(session.user.id);

              if (existing == null) {
                await usersRepo.insertUser(
                  id: session.user.id,
                  email: session.user.email ?? '',
                  firstName: '',
                  lastName: '',
                );
              }
            } catch (e) {
              // Network or DB error, ignore for now as it's a background sync
            }
          },
          loading: () {},
          error: (_, __) {},
        );
      },
    );

    return MaterialApp.router(
      title: title,
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: buildTheme(),
      darkTheme: buildTheme(),
      themeMode: themeMode,
      showPerformanceOverlay: debugState.showPerformanceOverlay,
    );
  }
}
