import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../styles/theme_manager.dart';

class NavBar extends StatelessWidget {
  final Widget child;

  const NavBar({super.key, required this.child});

  int _locationToIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/activity')) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/activity');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavBarView(
      currentIndex: _locationToIndex(context),
      onTap: (i) => _onTap(context, i),
      child: child,
    );
  }
}

class NavBarView extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const NavBarView({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: appColors.primaryOne,
        currentIndex: currentIndex,
        onTap: onTap,
        selectedItemColor: appColors.primaryTwo,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: currentIndex == 0 ? 30 : 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1 ? Icons.history_rounded : Icons.history,
              size: currentIndex == 1 ? 30 : 24,
            ),
            label: 'PastActivity',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2 ? Icons.person : Icons.person_outline,
              size: currentIndex == 2 ? 30 : 24,
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3 ? Icons.settings : Icons.settings_outlined,
              size: currentIndex == 3 ? 30 : 24,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
