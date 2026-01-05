import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? message;
  final VoidCallback onHome;

  const ErrorPage({
    super.key,
    this.message,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Oops, something went wrong',
              style: const TextStyle(fontSize: 18),
            ),
            if (kDebugMode && message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onHome,
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
