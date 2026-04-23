import 'dart:math' as math;

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
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
            child: Material(
              color: AppThemeManager.primaryBackground,
              clipBehavior: Clip.antiAlias, // Ensures children and ripple are clipped
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: appColors.containersBorders),
              ),
              child: InkWell(
                onTap: () async {
                  _controller.forward(from: 0.0);
                  await widget.onPressed?.call();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title section with conditional background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: widget.isOpen ? AppThemeManager.secondaryBackground : Colors.transparent,
                        // Providing explicit radius to avoid clipping artifacts at the corners
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Item title
                          Expanded(
                            child: Text(
                              widget.title,
                              style: AppTextStyles.bodyLarge(context),
                            ),
                          ),

                          // Transform widget to rotate the underlying icon
                          Transform.rotate(
                            angle: (widget.isOpen == true ? 180.0 : 0.0) * (math.pi / 180),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppThemeManager.primaryText,
                              size: 24,
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
                        color: appColors.containersBorders,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                        child: Text(
                          widget.description,
                          style: AppTextStyles.labelMedium(context),
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
          );
        });
  }
}
