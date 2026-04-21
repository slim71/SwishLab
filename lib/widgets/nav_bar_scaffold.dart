import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/session.dart';
import 'nav_bar.dart';

class NavBarScaffold extends ConsumerWidget {
  final Widget child;

  const NavBarScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Delay the provider update and the dialog creation until after build completion
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationContextProvider.notifier).state = context;
    });

    // Trigger session bootstrap: used for one-time only actions
    ref.watch(sessionBootstrapProvider);

    return Scaffold(
      bottomNavigationBar: NavBar(child: child),
      body: child,
    );
  }
}
