import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';

/// Custom widget to use as a list item with title and hideable description
class FaqItem extends StatefulWidget {
  final bool isOpen;
  final String title;
  final String description;
  final Future<void> Function()? onPressed;

  const FaqItem({
    super.key,
    this.isOpen = false,
    this.title = 'Item title',
    this.description = 'Some description',
    required this.onPressed,
  });

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with TickerProviderStateMixin {
  var hasTextTriggered = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 600.ms);
    if (widget.isOpen) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FaqItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen != oldWidget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppThemeManager.secondaryBackground.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        _controller.forward(from: 0.0);
                        await widget.onPressed?.call();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Item title
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: AppTextStyles.titleMedium(context, color: AppThemeManager.primaryText),
                                  ),
                                ),

                                // Transform widget to rotate the underlying icon
                                Transform.rotate(
                                  angle: (widget.isOpen == true ? 180.0 : 0.0) * (math.pi / 180),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppThemeManager.primaryText.withValues(alpha: 0.7),
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Separator line and description text, hideable
                          if (widget.isOpen == true) ...[
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.white.withValues(alpha: 0.1),
                              indent: 20,
                              endIndent: 20,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 20),
                              child: Text(
                                widget.description,
                                style: AppTextStyles.bodyMedium(context,
                                    color: AppThemeManager.primaryText.withValues(alpha: 0.8)),
                              ).animate(controller: _controller).fade(
                                    begin: 0,
                                    end: 1,
                                    duration: 600.ms,
                                    curve: Curves.easeInOut,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
