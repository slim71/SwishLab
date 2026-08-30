import 'package:flutter/material.dart';

import '../constants.dart';
import '../logger.dart';
import '../models/custom_enums.dart';
import '../styles/theme_manager.dart';

/// Widget to load an asset based on the supplied string.
///
/// A local asset is preferred, if present, otherwise it searches for it in
/// the project's database (Supabase).
class DynamicAsset extends StatefulWidget {
  static final _logger = AppLogger.scope('DynamicAsset');
  const DynamicAsset({
    super.key,
    this.width,
    this.height,
    required this.name,
    this.type = 'icon',
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final String name;
  final String type;
  final BoxFit fit;

  @override
  State<DynamicAsset> createState() => _DynamicAssetState();
}

class _DynamicAssetState extends State<DynamicAsset> {
  static const String supabaseRoot = '$supabaseDomain/storage/v1/object/public/';
  static const String iconNetworkPath = "Icons";
  static const String iconLocalPath = "assets/icons";
  static const String imagePath = "assets/images";
  static const String gifPath = "assets/gifs";

  static const Map<String, AssetType> _typeMap = {
    'icon': AssetType.icon,
    'image': AssetType.image,
    'gif': AssetType.gif,
  };

  List<String> _candidates = const <String>[];
  final Set<String> _failedPaths = <String>{};
  int _currentIndex = 0;

  late String normalizedName;
  late AssetType typeEnum;
  late String? fileExtension;

  @override
  void initState() {
    super.initState();
    _initParameters();
    _candidates = _buildCandidates();
  }

  @override
  void didUpdateWidget(DynamicAsset oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.name != oldWidget.name || widget.type != oldWidget.type) {
      setState(() {
        _currentIndex = 0;
        _failedPaths.clear();
        _initParameters();
        _candidates = _buildCandidates();
      });
    }
  }

  void _initParameters() {
    if (widget.name.startsWith('http')) {
      normalizedName = widget.name;
      fileExtension = widget.name.split('.').last.toLowerCase();
    } else {
      final parts = widget.name.split('.');
      final nameWithoutExtension = parts.first;
      fileExtension = parts.length > 1 ? parts.last.toLowerCase() : null;
      normalizedName = nameWithoutExtension.toLowerCase().trim().replaceAll(RegExp(r'[\s\-_]+'), '_');
    }

    typeEnum = _typeMap[widget.type.toLowerCase()] ?? AssetType.icon;
  }

  List<String> _buildCandidates() {
    if (widget.name.startsWith('http')) {
      return [widget.name];
    }

    String root = supabaseRoot;
    if (root.endsWith('/')) {
      root = root.substring(0, root.length - 1);
    }

    switch (typeEnum) {
      case AssetType.icon:
        final ext = fileExtension ?? 'png';
        return [
          '$iconLocalPath/$normalizedName.$ext',
          '$root/$iconNetworkPath/$normalizedName.$ext',
          '$iconLocalPath/default_icon.png',
          '$root/$iconNetworkPath/default_icon.png',
        ];

      case AssetType.image:
        final ext = fileExtension ?? 'png';
        return [
          '$imagePath/$normalizedName.$ext',
          '$root/$imagePath/$normalizedName.$ext',
        ];

      case AssetType.gif:
        return [
          '$gifPath/$normalizedName.gif',
          '$root/$gifPath/$normalizedName.gif',
          '$gifPath/$normalizedName.png', // Fallback
          '$gifPath/$normalizedName.jpg', // Fallback
        ];
    }
  }

  void _onLoadError(String failedPath, dynamic error) {
    if (_failedPaths.contains(failedPath)) return;

    _failedPaths.add(failedPath);
    DynamicAsset._logger.w('Failed to load asset: $failedPath. Error: $error.');

    if (_currentIndex < _candidates.length - 1) {
      DynamicAsset._logger.i('Trying next candidate...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex++;
          });
        }
      });
    } else {
      DynamicAsset._logger.e('All candidates exhausted for "${widget.name}".');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _candidates.length) {
      DynamicAsset._logger.e('All candidates exhausted for "${widget.name}". Checked: $_candidates');
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: (widget.width ?? 24) / 2),
            const Text('Not Found', style: TextStyle(color: Colors.red, fontSize: 8)),
          ],
        ),
      );
    }

    final path = _candidates[_currentIndex];
    DynamicAsset._logger.d('BUILDING ASSET: Index: $_currentIndex, Path: $path, Type: ${widget.type}');

    return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, __, ___) {
        return Image(
          key: ValueKey('asset_${_currentIndex}_$path'),
          image: path.startsWith('http') ? NetworkImage(path) : AssetImage(path) as ImageProvider,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (context, error, stackTrace) {
            _onLoadError(path, error);
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
