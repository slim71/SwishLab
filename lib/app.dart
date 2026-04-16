import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swish_lab/providers/session.dart';
import 'package:swish_lab/providers/supabase_provider.dart';
import 'package:swish_lab/providers/users_provider.dart';
import 'package:swish_lab/router/central_routing.dart' show routerProvider;
import 'package:swish_lab/styles/colors.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/styles/themes.dart';

// Expose the app title globally through this one provider
final appTitleProvider = Provider((_) => 'SwishLab');
// Root widget of the app
class SwishLab extends ConsumerStatefulWidget {
  const SwishLab({super.key});

  @override
  ConsumerState<SwishLab> createState() => _SwishLabState();
}

class _SwishLabState extends ConsumerState<SwishLab> {
  AppColorSet currentColors = theBay;
  Brightness brightness = Brightness.light;

  void updateTheme(AppColorSet newColors, Brightness newBrightness) {
    setState(() {
      currentColors = newColors;
      brightness = newBrightness;
      AppThemeManager.setColors(newColors);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final title = ref.watch(appTitleProvider);
    ref.watch(supabaseAuthListenerProvider); // triggers creation

    // Listener to add the user to the DB
    ref.listen<AsyncValue<Session?>>(
      verifiedSessionProvider,
      (previous, next) {
        next.when(
          data: (session) async {
            if (session == null) return;

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
          },
          loading: () {},
          error: (_, __) {},
        );
      },
    );

    return MaterialApp.router(
      title: title,
      routerConfig: router,
      theme: buildTheme(),
      darkTheme: buildTheme(),
      themeMode: ThemeMode.system, // Auto-switch based on device
    );
  }
}
