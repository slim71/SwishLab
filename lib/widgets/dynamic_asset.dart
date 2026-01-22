import 'dart:async';

import 'package:SwishLab/constants.dart';
import 'package:SwishLab/models/custom_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

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
  String? _resolvedPath;

  static const String supabaseRoot = '$supabaseDomain/storage/v1/object/public/';
  static const String iconNetworkPath = "Icons";
  static const String iconLocalPath = "assets/icons";
  static const String imagePath = "assets/images";
  static const String jsonPath = "assets/json";
  static const String gifPath = "assets/gifs";
  static const String animationPath = "assets/animations";

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
    // Normalize name: lowercase and replace spaces with underscores
    normalizedName = nameWithoutExtension.toLowerCase().replaceAll(' ', '_');

    // Convert string from JSON to enum
    typeEnum = {
          'icon': AssetType.icon,
          'image': AssetType.image,
          'json': AssetType.json,
          'animation': AssetType.animation,
          'gif': AssetType.gif,
        }[widget.type.toLowerCase()] ??
        AssetType.icon;

    _resolveAsset();
  }

  /// Determines which asset path to use based on type and availability
  Future<void> _resolveAsset() async {
    switch (typeEnum) {
      case AssetType.icon:
        normalizedPlusExtension = fileExtension != null ? '$normalizedName.$fileExtension' : '$normalizedName.png';
        // For icons, try: local -> network -> default local -> default network
        await _tryLocal('$iconLocalPath/$normalizedPlusExtension') ||
            await _tryNetwork('$supabaseRoot/$iconNetworkPath/$normalizedPlusExtension') ||
            await _tryLocal('$iconLocalPath/default_icon.png') ||
            await _tryNetwork('$supabaseRoot/$iconNetworkPath/default_icon.png');
        break;

      case AssetType.image:
        normalizedPlusExtension = fileExtension != null ? '$normalizedName.$fileExtension' : '$normalizedName.png';
        // For images, only local -> network fallback
        await _tryLocal('$imagePath/$normalizedPlusExtension') ||
            await _tryNetwork('$supabaseRoot/$imagePath/$normalizedPlusExtension');
        break;

      case AssetType.json:
        normalizedPlusExtension = '$normalizedName.json';
        await _tryLocal('$jsonPath/$normalizedPlusExtension') ||
            await _tryNetwork('$supabaseRoot/$jsonPath/$normalizedPlusExtension');
        break;

      case AssetType.animation:
        normalizedPlusExtension = fileExtension != null ? '$normalizedName.$fileExtension' : '$normalizedName.json';

        final candidateLocal = '$animationPath/$normalizedPlusExtension';

        // Store local first
        _resolvedPath = candidateLocal;

        break;

      case AssetType.gif:
        normalizedPlusExtension = '$normalizedName.gif';
        await _tryLocal('$gifPath/$normalizedPlusExtension') ||
            await _tryNetwork('$supabaseRoot/$gifPath/$normalizedPlusExtension');
        break;
    }

    // Trigger rebuild after resolving asset
    setState(() {});
  }

  /// Tries to load a local asset. Returns true if successful.
  Future<bool> _tryLocal(String path) async {
    final completer = Completer<bool>();
    try {
      final img = Image.asset(path);
      final stream = img.image.resolve(const ImageConfiguration());
      late ImageStreamListener listener;

      listener = ImageStreamListener(
        (info, _) {
          if (!completer.isCompleted) completer.complete(true);
          stream.removeListener(listener);
        },
        onError: (error, stackTrace) {
          if (!completer.isCompleted) completer.complete(false);
          stream.removeListener(listener);
        },
      );

      stream.addListener(listener);
      await completer.future;

      if (completer.isCompleted && completer.future == Future.value(true)) {
        _resolvedPath = path;
        debugPrint('DynamicAsset -> using local asset: $_resolvedPath');
      }
      return await completer.future;
    } catch (e) {
      debugPrint('DynamicAsset -> local asset not found or invalid: $path ($e)');
      return false;
    }
  }

  Future<bool> _tryNetwork(String url) async {
    final completer = Completer<bool>();
    final cacheBustedUrl = "$url?v=${DateTime.now().millisecondsSinceEpoch}";
    final img = Image.network(cacheBustedUrl);
    final stream = img.image.resolve(const ImageConfiguration());
    late ImageStreamListener listener;

    listener = ImageStreamListener(
      (info, _) {
        if (!completer.isCompleted) completer.complete(true);
        stream.removeListener(listener);
      },
      onError: (error, stackTrace) {
        if (!completer.isCompleted) completer.complete(false);
        stream.removeListener(listener);
      },
    );

    stream.addListener(listener);
    final success = await completer.future;

    if (success) {
      _resolvedPath = cacheBustedUrl;
      debugPrint('DynamicAsset -> using network asset: $_resolvedPath');
    } else {
      debugPrint('DynamicAsset -> failed to load network image: $cacheBustedUrl');
    }

    return success;
  }

  @override
  Widget build(BuildContext context) {
    if (_resolvedPath == null) {
      // Asset still being resolved
      debugPrint('DynamicAsset -> resolving asset...');
      return const SizedBox.shrink();
    }

    // For Lottie animations
    if (typeEnum == AssetType.animation) {
      final path = _resolvedPath!;

      if (path.startsWith('http')) {
        return Lottie.network(path, width: widget.width, height: widget.height);
      } else {
        return Lottie.asset(path, width: widget.width, height: widget.height);
      }
    }

    // For all other types: load as image or network
    final imageProvider =
        _resolvedPath!.startsWith('http') ? NetworkImage(_resolvedPath!) : AssetImage(_resolvedPath!) as ImageProvider;

    return Image(
      image: imageProvider,
      width: widget.width,
      height: widget.height,
      errorBuilder: _imageErrorBuilder,
    );
  }

  /// Handles error while loading images: fallback to a default icon if needed
  Widget _imageErrorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
    debugPrint('DynamicAsset -> failed to load $_resolvedPath, showing default');
    return Image.asset(
      'assets/icons/default_icon.png',
      width: widget.width,
      height: widget.height,
    );
  }
}