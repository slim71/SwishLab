import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../constants.dart';
import '../models/custom_enums.dart';
import '../styles/theme_manager.dart';

/// Widget to upload an asset based on the supplied string.
///
/// A local asset is preferred, if present, otherwise it searches for it in
/// the project's database
class DynamicAsset extends StatefulWidget {
  const DynamicAsset({
    super.key,
    this.width,
    this.height,
    required this.name,
    this.type = 'icon',
  });

  final double? width;
  final double? height;
  final String name;
  final String type;

  @override
  State<DynamicAsset> createState() => _DynamicAssetState();
}

class _DynamicAssetState extends State<DynamicAsset> {
  static const String supabaseRoot = '$supabaseDomain/storage/v1/object/public/';
  static const String iconNetworkPath = "Icons";
  static const String iconLocalPath = "assets/icons";
  static const String imagePath = "assets/images";
  static const String jsonPath = "assets/json";
  static const String gifPath = "assets/gifs";
  static const String animationPath = "assets/lottie";

  List<String> _candidates = const [];
  int _currentIndex = 0;

  late final String normalizedName;
  late final AssetType typeEnum;
  late final String? normalizedPlusExtension;
  late final String? fileExtension;

  @override
  void initState() {
    super.initState();

    // Split name and extension (if present)
    final parts = widget.name.split('.');
    final nameWithoutExtension = parts.first;
    fileExtension = parts.length > 1 ? parts.last.toLowerCase() : null;
    // Normalize name: lowercase and replace spaces/dashes with underscores
    normalizedName = nameWithoutExtension.toLowerCase().trim().replaceAll(RegExp(r'[\s\-_]+'), '_');

    // Convert string from JSON to enum
    typeEnum = {
          'icon': AssetType.icon,
          'image': AssetType.image,
          'json': AssetType.json,
          'animation': AssetType.animation,
          'gif': AssetType.gif,
        }[widget.type.toLowerCase()] ??
        AssetType.icon;

    _candidates = _buildCandidates();
  }

  List<String> _buildCandidates() {
    switch (typeEnum) {
      case AssetType.icon:
        final ext = fileExtension ?? 'png';
        return [
          '$iconLocalPath/$normalizedName.$ext',
          '$supabaseRoot/$iconNetworkPath/$normalizedName.$ext',
          '$iconLocalPath/default_icon.png',
          '$supabaseRoot/$iconNetworkPath/default_icon.png',
        ];

      case AssetType.image:
        final ext = fileExtension ?? 'png';
        return [
          '$imagePath/$normalizedName.$ext',
          '$supabaseRoot/$imagePath/$normalizedName.$ext',
        ];

      case AssetType.gif:
        return [
          '$gifPath/$normalizedName.gif',
          '$supabaseRoot/$gifPath/$normalizedName.gif',
        ];

      case AssetType.json:
        return [
          '$jsonPath/$normalizedName.json',
          '$supabaseRoot/$jsonPath/$normalizedName.json',
        ];

      case AssetType.animation:
        final ext = fileExtension ?? 'json';
        return [
          '$animationPath/$normalizedName.$ext',
          '$supabaseRoot/$animationPath/$normalizedName.$ext',
        ];
    }
  }

  Widget _next() {
    final path = _candidates[_currentIndex];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _currentIndex++);
      }
    });
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _candidates.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final path = _candidates[_currentIndex];

    if (typeEnum == AssetType.animation) {
      return path.startsWith('http')
          ? ValueListenableBuilder(
              valueListenable: AppThemeManager.notifier,
              builder: (_, __, ___) {
                return Container(
                    color: AppThemeManager.primaryBackground,
                    child: Lottie.network(
                      path,
                      width: widget.width,
                      height: widget.height,
                      errorBuilder: (_, __, ___) => _next(),
                    ));
              })
          : ValueListenableBuilder(
              valueListenable: AppThemeManager.notifier,
              builder: (_, __, ___) {
                return Container(
                    color: AppThemeManager.primaryBackground,
                    child: Lottie.asset(
                      path,
                      width: widget.width,
                      height: widget.height,
                      errorBuilder: (_, __, ___) => _next(),
                    ));
              });
    }

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: AppThemeManager.primaryBackground,
              child: Image(
                image: path.startsWith('http')
                    ? NetworkImage(path) : AssetImage(path) as ImageProvider,
                width: widget.width,
                height: widget.height,
                errorBuilder: (_, __, ___) => _next(),
              ));
        });
  }
}
