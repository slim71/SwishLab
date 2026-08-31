import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'logger.dart';
import 'providers/shared_preferences_provider.dart';
import 'styles/theme_manager.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, __, ___) {
        return const SwishLab();
      },
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AppLogger.init();
    await AppThemeManager.init();

    // Initialize Supabase connection
    try {
      await Supabase.initialize(
        url: 'https://ccqvtpiltowjpogbjmpd.supabase.co',
        publishableKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNjcXZ0cGlsdG93anBvZ2JqbXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MDU0NDQsImV4cCI6MjA3MjM4MTQ0NH0.rCMRBmdjrpXug8_MCHD1L5K5XdSy4SdDO9eZtSS1B58',
      );
    } catch (e) {
      debugPrint("Supabase initialization failed: $e");
      // We continue because the app might have offline capabilities or fallback logic
    }

    final prefs = await SharedPreferences.getInstance();

    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint("Failed to load .env file: $e");
    }

    runApp(ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const Root(),
    ));
  } catch (e, stack) {
    debugPrint("CRITICAL INITIALIZATION FAILURE: $e\n$stack");
    // Attempt to show a basic error screen instead of hanging
    runApp(MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text("Fatal startup error:\n$e\n\nPlease check your internet and restart."),
          ),
        ),
      ),
    ));
  }
}
