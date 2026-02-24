import 'dart:math' as math;

import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Custom widget to use as a list item with title and hideable description
class FaqItem extends StatefulWidget {
  final bool isOpen;
  final String title;
  final String description;
  final Future Function()? onPressed;

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
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: AppThemeManager.primaryBackground,
              child:
                  // Main container for the whole content of the widget
                  Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                child: InkWell(
                  onTap: () async {
                    _controller.forward(from: 0.0);
                    await widget.onPressed?.call();
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: widget.isOpen == true ? 10.0 : 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 100),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppThemeManager.primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: appColors.containersBorders,
                        ),
                      ),
                      child:
                          // Main column for the whole content of the widget
                          Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row containing the title or header of the item, always shown
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container for the item title, always shown
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child:
                                        // Item title, always shown
                                        Text(
                                      widget.title,
                                      style: AppTextStyles.bodyLarge(context),
                                    ),
                                  ),
                                ),

                                // Transform widget to rotate the underlying icon
                                Transform.rotate(
                                  angle: (widget.isOpen == true ? 180.0 : 0.0) * (math.pi / 180),
                                  child:
                                      // Arrow icon
                                      Icon(
                                    Icons.arrow_drop_down,
                                    color: AppThemeManager.primaryText,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),

                            // Container for the description text, hideable
                            if (widget.isOpen == true)
                              Material(
                                color: Colors.transparent,
                                elevation: widget.isOpen == true ? 10.0 : 0.0,
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child:
                                      // Description text, hideable
                                  Visibility(
                                    visible: widget.isOpen == true,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
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
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
  }
}
