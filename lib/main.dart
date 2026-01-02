import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ccqvtpiltowjpogbjmpd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNjcXZ0cGlsdG93anBvZ2JqbXBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY4MDU0NDQsImV4cCI6MjA3MjM4MTQ0NH0.rCMRBmdjrpXug8_MCHD1L5K5XdSy4SdDO9eZtSS1B58',
  );

  await dotenv.load(fileName: ".env"); // if you use dotenv
  runApp(ProviderScope(child: SwishLab()));
}
