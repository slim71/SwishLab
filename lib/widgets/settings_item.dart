import 'package:flutter/material.dart';

class SettingsItem {
  final String title;
  final Color background;
  final VoidCallback? onTap;

  const SettingsItem({
    required this.title,
    required this.background,
    this.onTap,
  });
}
