import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'dynamic_icon_image.dart';

/// Custom bottom sheet to show more details of the section the user clicked
/// on
class SectionDetails extends ConsumerStatefulWidget {
  final Map<String, dynamic> sectionJson;

  const SectionDetails({
    super.key,
    required this.sectionJson,
  });

  @override
  ConsumerState<SectionDetails> createState() => _SectionDetailsState();
}

class _SectionDetailsState extends ConsumerState<SectionDetails> {
  double? sheetHeight;
  double? dragDelta = 69.69;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        sheetHeight = MediaQuery.sizeOf(context).height * 0.5;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    return ValueListenableBuilder(
        valueListenable: AppThemeManager.notifier,
        builder: (_, __, ___) {
          return Container(
              color: Colors.transparent,
              child:
                  // Stack to place the whole bottom sheet content
                  SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // GestureDetector to close the bottom sheet when clicking outside
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),

                    // Container for the actual bottom sheet
                    Align(
                      alignment: const AlignmentDirectional(0, 1),
                      child: Container(
                        width: double.infinity,
                        height: sheetHeight ?? 100,
                        decoration: BoxDecoration(
                          gradient: appColors.gradientBackground(),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0),
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child:
                            // Column containing the bottom sheet
                            Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Container for the top bar of the bottom sheet
                            GestureDetector(
                              onVerticalDragUpdate: (details) {
                                setState(() {
                                  sheetHeight = (sheetHeight! - details.delta.dy)
                                      .clamp(0.0, MediaQuery.sizeOf(context).height * 0.9);
                                });
                              },
                              onVerticalDragEnd: (details) {
                                // If dragged down too much or with high velocity, close the sheet
                                if (sheetHeight! < MediaQuery.sizeOf(context).height * 0.2 ||
                                    (details.primaryVelocity ?? 0) > 600) {
                                  Navigator.pop(context);
                                } else if (sheetHeight! < 150) {
                                  // Snap back to a minimum height if not closed
                                  setState(() {
                                    sheetHeight = 150;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: appColors.gradientBackground(),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                ),
                                child:
                                    // Row to place the top bar of the bottom sheet
                                    InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icon to highlight the top bar of the bottom sheet and give hints on how to handle it
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                                        child: FaIcon(
                                          FontAwesomeIcons.gripLines,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.black,
                            ),

                            // Column where to place the bottom sheet content
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Row to place the title of the Details section
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Details section title
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                          child: Text(
                                            'Details',
                                            style: AppTextStyles.titleLarge(context, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Row to place the reference header
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 16, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Area',
                                              style: AppTextStyles.bodySmall(context, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Measured',
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.bodySmall(context, color: Colors.black),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Ideal',
                                              textAlign: TextAlign.end,
                                              style: AppTextStyles.bodySmall(context, color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppThemeManager.secondaryBackground.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: appColors.alternateTwo.withValues(alpha: .5),
                                            width: 1,
                                          ),
                                        ),
                                        child:
                                            // Wrap to dynamically generate content for the Details section
                                            Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Builder(
                                            builder: (context) {
                                              final List<dynamic> sectionFields =
                                                  (widget.sectionJson['fields'] as List<dynamic>? ?? []);

                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: List.generate(sectionFields.length, (sectionFieldsIndex) {
                                                  final sectionFieldsItem = sectionFields[sectionFieldsIndex];
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      // Row to place details of an item
                                                      Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            // Row to place the item's icon and name
                                                            Expanded(
                                                              flex: 2,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  // Icon related to the detail in focus, dynamically gathered from its name
                                                                  SizedBox(
                                                                    width: 25,
                                                                    height: 25,
                                                                    child: DynamicIconImage(
                                                                      width: 25,
                                                                      height: 25,
                                                                      imageName:
                                                                          sectionFieldsItem['name']?.toString() ?? '',
                                                                    ),
                                                                  ),

                                                                  // Item's name
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          8, 0, 0, 0),
                                                                      child: Text(
                                                                        sectionFieldsItem['name']?.toString() ?? '',
                                                                        style: AppTextStyles.bodyMedium(context),
                                                                        overflow: TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Row to place an item's value and unit
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  // Item's value
                                                                  Text(
                                                                    (() {
                                                                      final val = sectionFieldsItem['value'];
                                                                      if (val == null) return '';

                                                                      // Try to parse as double for 2-digit formatting
                                                                      double? dVal;
                                                                      if (val is num) {
                                                                        dVal = val.toDouble();
                                                                      } else if (val is String) {
                                                                        dVal = double.tryParse(val);
                                                                      }

                                                                      if (dVal != null) {
                                                                        return dVal.toStringAsFixed(2);
                                                                      }
                                                                      return val.toString();
                                                                    })(),
                                                                    style: AppTextStyles.bodyMedium(context).copyWith(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),

                                                                  const SizedBox(width: 4),

                                                                  // Item's unit of measurement
                                                                  Text(
                                                                    sectionFieldsItem['unit']?.toString() ?? '',
                                                                    style: AppTextStyles.bodySmall(context),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            // Row to place the considered range of the item's value
                                                            Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                children: [
                                                                  // Item's value range
                                                                  Text(
                                                                    sectionFieldsItem['range']?.toString() ?? '',
                                                                    style: AppTextStyles.bodySmall(context)
                                                                        .copyWith(color: Colors.black),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (sectionFieldsIndex < sectionFields.length - 1)
                                                        Divider(
                                                          height: 1,
                                                          thickness: 1,
                                                          indent: 12,
                                                          endIndent: 12,
                                                          color: appColors.alternateTwo.withValues(alpha: .3),
                                                        ),
                                                    ],
                                                  );
                                                }),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Row to place the title of the Scores section
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Scores section title
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                          child: Text(
                                            'Scores',
                                            style: AppTextStyles.titleLarge(context, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppThemeManager.secondaryBackground.withValues(alpha: .4),
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: appColors.alternateTwo.withValues(alpha: .5),
                                          ),
                                        ),
                                        child:
                                            // Wrap to dynamically generate content for the Scores section
                                            Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 4),
                                          child: Builder(
                                            builder: (context) {
                                              final scoresJson = (widget.sectionJson['scores'] as List<dynamic>?) ?? [];

                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: List.generate(scoresJson.length, (scoresJsonIndex) {
                                                  final scoresJsonItem = scoresJson[scoresJsonIndex];
                                                  return Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      // Container to place each feedback item
                                                      Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            // Row to place the score of an item
                                                            Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                // Row to place the icon and name related to the item's category score
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    // Icon related to the score in focus, dynamically gathered from its name
                                                                    SizedBox(
                                                                      width: 25,
                                                                      height: 25,
                                                                      child: DynamicIconImage(
                                                                        width: 25,
                                                                        height: 25,
                                                                        imageName:
                                                                            scoresJsonItem['name']?.toString() ?? '',
                                                                      ),
                                                                    ),

                                                                    // Item's name
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          8, 0, 0, 0),
                                                                      child: Text(
                                                                        scoresJsonItem['name']?.toString() ?? '',
                                                                        style:
                                                                            AppTextStyles.bodyMedium(context).copyWith(
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                // Row to place the actual score for this category
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  children: [
                                                                    // Score value
                                                                    Text(
                                                                      scoresJsonItem['value']?.toString() ?? '',
                                                                      style: AppTextStyles.bodyMedium(context).copyWith(
                                                                        fontWeight: FontWeight.bold,
                                                                        color: AppThemeManager.primaryText,
                                                                      ),
                                                                    ),

                                                                    // Star icon
                                                                    const Padding(
                                                                      padding:
                                                                          EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                                                      child: SizedBox(
                                                                        width: 20,
                                                                        height: 20,
                                                                        child: DynamicIconImage(
                                                                          width: 20,
                                                                          height: 20,
                                                                          imageName: 'star',
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),

                                                            // Row to place the feedback text
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.max,
                                                                children: [
                                                                  // Container to place the feedback text
                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppThemeManager.primaryBackground
                                                                            .withValues(alpha: .5),
                                                                        borderRadius: BorderRadius.circular(12),
                                                                        border: Border.all(
                                                                          color: appColors.altContBorders
                                                                              .withValues(alpha: .5),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          // Feedback related to the user's score for this category
                                                                          Padding(
                                                                        padding: const EdgeInsets.all(12),
                                                                        child: Text(
                                                                          'Some feedback to download or I don\'t know how to gather',
                                                                          textAlign: TextAlign.start,
                                                                          style:
                                                                              AppTextStyles.bodySmall(context).copyWith(
                                                                            fontStyle: FontStyle.italic,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (scoresJsonIndex < scoresJson.length - 1)
                                                        Divider(
                                                          height: 1,
                                                          thickness: 1,
                                                          indent: 12,
                                                          endIndent: 12,
                                                          color: appColors.alternateTwo.withValues(alpha: .3),
                                                        ),
                                                    ],
                                                  );
                                                }),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
