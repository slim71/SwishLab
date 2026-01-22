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

    return
        // Main container for the whole content of the widget
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Semantics(
        label: 'Main container',
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                color: appColors.secondaryBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: appColors.containersBorders,
                ),
              ),
              child:
                  // Main column for the whole content of the widget
                  Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
                child: Semantics(
                  label: 'Main column',
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row containing the title or header of the item, always shown
                      Semantics(
                        label: 'Title row',
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container for the item title, always shown
                            Expanded(
                              child: Semantics(
                                label: 'Title container',
                                child: Container(
                                  decoration: BoxDecoration(),
                                  child:
                                      // Item title, always shown
                                      Semantics(
                                    label: 'Item title',
                                    child: Text(
                                      widget.title,
                                      style: AppTextStyles.bodyLarge(),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Transform widget to rotate the underlying icon
                            Semantics(
                              label: 'Transform to rotate icon',
                              child: Transform.rotate(
                                angle: (widget.isOpen == true ? 180.0 : 0.0) * (math.pi / 180),
                                child:
                                    // Arrow icon
                                    Semantics(
                                  label: 'Arrow icon',
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: appColors.primaryText,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container for the description text, hideable
                      if (widget.isOpen == true)
                        Semantics(
                          label: 'Description container',
                          child: Material(
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
                                  child: Semantics(
                                    label: 'Description text',
                                    child: Text(
                                      widget.description,
                                      style: AppTextStyles.labelMedium(),
                                    ),
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
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
