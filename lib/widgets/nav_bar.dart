import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/central_routing.dart';
import '../styles/theme_manager.dart';

/// The total height occupied by the floating NavBar (height + bottom margin)
const double kNavBarHeight = 90.0;

class NavBar extends ConsumerWidget {
  final Widget child;

  const NavBar({super.key, required this.child});

  int _locationToIndex(BuildContext context, WidgetRef ref) {
    String location = '/';
    try {
      // GoRouterState is the preferred way to get the current location
      location = GoRouterState.of(context).uri.toString();
    } catch (_) {
      // Fallback for tests or environments where GoRouterState isn't available
      final router = ref.read(routerProvider);
      final configuration = router.routerDelegate.currentConfiguration;
      if (configuration.isEmpty) {
        location = '/';
      } else {
        location = configuration.last.matchedLocation;
      }
    }

    if (location.startsWith('/activity')) return 1;
    if (location.startsWith('/profile')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    // Add Haptic Feedback
    HapticFeedback.lightImpact();
    final router = ref.read(routerProvider);

    switch (index) {
      case 0:
        router.go('/home');
        break;
      case 1:
        router.go('/activity');
        break;
      case 2:
        router.go('/profile');
        break;
      case 3:
        router.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavBarView(
      currentIndex: _locationToIndex(context, ref),
      onTap: (i) => _onTap(context, ref, i),
      child: child,
    );
  }
}

/// A view that renders a floating, glass-morphic navigation bar.
///
/// Because [extendBody] is set to true, the [child] will flow behind the
/// transparent navigation bar.
///
/// IMPORTANT: To ensure that the bottom-most content of the [child] is not
/// permanently hidden behind the bar, the [child] should include a bottom
/// padding of at least [kNavBarHeight] (90px).
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
      extendBody: true, // Content flows behind the floating nav bar
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          height: 70,
          decoration: BoxDecoration(
            color: appColors.primaryOne.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                  _buildNavItem(1, Icons.history_rounded, Icons.history_outlined, 'Activity'),
                  _buildNavItem(2, Icons.person_rounded, Icons.person_outline_rounded, 'Profile'),
                  _buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = currentIndex == index;
    final appColors = AppThemeManager.currentColors;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap?.call(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? appColors.primaryTwo.withValues(alpha: 0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? appColors.primaryTwo : Colors.white.withValues(alpha: 0.6),
                size: isSelected ? 30 : 26,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? appColors.primaryTwo : Colors.white.withValues(alpha: 0.6),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: appColors.primaryTwo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: appColors.primaryTwo.withValues(alpha: 0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
