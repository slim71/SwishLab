import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/session.dart';
import 'nav_bar.dart';

class NavBarScaffold extends ConsumerWidget {
  final Widget child;

  const NavBarScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Trigger session bootstrap: used for one-time only actions
    ref.watch(sessionBootstrapProvider);

    return Scaffold(
      bottomNavigationBar: NavBar(child: child),
      body: child,
    );
  }
}
