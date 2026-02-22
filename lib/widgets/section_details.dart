import 'dart:math' as math;

import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/dynamic_icon_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  double? sheetHeight = 100.0;
  double? dragDelta = 69.69;

  @override
  void initState() {
    super.initState();
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
                  // Stack to place the whole bottom sheet content
                  SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    // Container for the actual bottom sheet
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Container(
                        width: double.infinity,
                        height: sheetHeight,
                        decoration: BoxDecoration(
                          color: AppThemeManager.primaryBackground,
                          borderRadius: BorderRadius.only(
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
                            SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Container for the top bar of the bottom sheet
                              GestureDetector(
                                onVerticalDragUpdate: (details) async {
                                  sheetHeight = math.max(
                                      100,
                                      math.min(
                                          (sheetHeight!) - details.delta.dy, MediaQuery.sizeOf(context).height * 0.9));
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: appColors.gradientBackground(),
                                    borderRadius: BorderRadius.only(
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
                                    child: Row(
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

                              // Column where to place the bottom sheet content
                              SingleChildScrollView(
                                primary: false,
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                          child: Text(
                                            'Details',
                                            style: AppTextStyles.titleLarge(),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Material(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: appColors.alternateTwo,
                                            width: 1,
                                          ),
                                        ),
                                        child:
                                            // Wrap to dynamically generate content for the Details section
                                            Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                          child: Builder(
                                            builder: (context) {
                                              final List<dynamic> sectionFields =
                                                  (widget.sectionJson['fields'] as List<dynamic>? ?? []);

                                              return Wrap(
                                                spacing: 0,
                                                runSpacing: 0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment: WrapCrossAlignment.start,
                                                direction: Axis.horizontal,
                                                runAlignment: WrapAlignment.start,
                                                verticalDirection: VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: List.generate(sectionFields.length, (sectionFieldsIndex) {
                                                  final sectionFieldsItem = sectionFields[sectionFieldsIndex];
                                                  return
                                                      // Row to place details of an item
                                                      Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          // Row to place the item's icon and name
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            // Icon related to the detail in focus, dynamically gathered from its name
                                                            SizedBox(
                                                              width: 25,
                                                              height: 25,
                                                              child: DynamicIconImage(
                                                                width: 25,
                                                                height: 25,
                                                                imageName: sectionFieldsItem['name']?.toString() ?? '',
                                                              ),
                                                            ),

                                                            // Item's name
                                                              Padding(
                                                                padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                                child: Text(
                                                                  sectionFieldsItem['name']?.toString() ?? '',
                                                                  style: AppTextStyles.bodyMedium(),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(width: 20),

                                                          // Row to place an item's value and unit
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            // Item's value
                                                            Text(
                                                              sectionFieldsItem['value']?.toString() ?? '',
                                                              style: AppTextStyles.bodyMedium(),
                                                            ),

                                                            const SizedBox(width: 5),

                                                            // Item's unit of measurement
                                                            Text(
                                                              sectionFieldsItem['unit']?.toString() ?? '',
                                                              style: AppTextStyles.bodyMedium(),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(width: 20),

                                                          // Row to place the considered range of the item's value
                                                        Row(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            // Item's value range
                                                            Text(
                                                              sectionFieldsItem['range']?.toString() ?? '',
                                                              style: AppTextStyles.bodyMedium(),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                      ),
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                          child: Text(
                                            'Scores',
                                            style: AppTextStyles.titleLarge(),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Material(
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: appColors.alternateTwo,
                                          ),
                                        ),
                                        child:
                                            // Wrap to dynamically generate content for the Scores section
                                            Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                                          child: Builder(
                                            builder: (context) {
                                              final scoresJson = (widget.sectionJson['scores'] as List<dynamic>?) ?? [];

                                              return Wrap(
                                                spacing: 0,
                                                runSpacing: 0,
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment: WrapCrossAlignment.start,
                                                direction: Axis.horizontal,
                                                runAlignment: WrapAlignment.start,
                                                verticalDirection: VerticalDirection.down,
                                                clipBehavior: Clip.none,
                                                children: List.generate(scoresJson.length, (scoresJsonIndex) {
                                                  final scoresJsonItem = scoresJson[scoresJsonIndex];
                                                  return
                                                      // Container to place each feedback item
                                                      Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(),
                                                      child: Column(
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: [
                                                            // Row to place the score of an item
                                                            Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                                                            child: Row(
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
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5, 0, 0, 0),
                                                                        child: Text(
                                                                          scoresJsonItem['name']?.toString() ??
                                                                              '',
                                                                          style: AppTextStyles.bodyMedium(),
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
                                                                      style: AppTextStyles.bodyMedium(),
                                                                    ),

                                                                    // Star icon
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5, 0, 0, 0),
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
                                                            ),

                                                            // Row to place the feedback text
                                                            Padding(
                                                              padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: [
                                                                // Container to place the feedback text
                                                                Expanded(
                                                                  child: Material(
                                                                    color: Colors.transparent,
                                                                    elevation: 10,
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: AppThemeManager.primaryBackground,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        border: Border.all(
                                                                          color: appColors.altContBorders,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          // Feedback related to the user's score for this category
                                                                          Padding(
                                                                        padding: EdgeInsets.all(5),
                                                                        child: Text(
                                                                          'Some feedback to download or I don\'t know how to gather',
                                                                          textAlign: TextAlign.start,
                                                                          style: AppTextStyles.bodyMedium(),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
