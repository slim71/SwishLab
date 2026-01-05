import 'package:SwishLab/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class NavBarScaffold extends StatelessWidget {
  final Widget child;

  const NavBarScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(child: child),
      body: child,
    );
  }
}
