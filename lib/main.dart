import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

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

  // Initialize Supabase connection
  await Supabase.initialize(
    url: 'https://ccqvtpiltowjpogbjmpd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNjcXZ0cGlsdG93anBvZ2JqbXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MDU0NDQsImV4cCI6MjA3MjM4MTQ0NH0.rCMRBmdjrpXug8_MCHD1L5K5XdSy4SdDO9eZtSS1B58',
  );

  await dotenv.load(fileName: ".env"); // TODO: use later
  runApp(ProviderScope(child: Root()));
}
