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
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(0, 1),
                    child: Container(
                      width: double.infinity,
                      height: sheetHeight ?? 100,
                      decoration: BoxDecoration(
                        gradient: appColors.gradientBackground(),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        border: Border.all(width: 1),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onVerticalDragUpdate: (details) {
                              setState(() {
                                sheetHeight = (sheetHeight! - details.delta.dy)
                                    .clamp(0.0, MediaQuery.sizeOf(context).height * 0.9);
                              });
                            },
                            onVerticalDragEnd: (details) {
                              if (sheetHeight! < MediaQuery.sizeOf(context).height * 0.2 ||
                                  (details.primaryVelocity ?? 0) > 600) {
                                Navigator.pop(context);
                              } else if (sheetHeight! < 150) {
                                setState(() => sheetHeight = 150);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: appColors.gradientBackground(),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              child: InkWell(
                                onTap: () => Navigator.pop(context),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      child: FaIcon(FontAwesomeIcons.gripLines, color: Colors.black, size: 25),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 1, thickness: 1, color: Colors.black),
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [Colors.black, Colors.transparent],
                                        stops: [0.6, 1.0],
                                      ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: Opacity(
                                      opacity: 0.5,
                                      child: Image.asset(
                                        (() {
                                          final section = widget.sectionJson['section']?.toString().toLowerCase() ?? '';
                                          if (section.contains('side')) return 'assets/images/ai_side.png';
                                          if (section.contains('front')) return 'assets/images/ai_front.jpg';
                                          if (section.contains('jump')) return 'assets/images/gs_4.png';
                                          return 'assets/images/ai_general.jpg';
                                        })(),
                                        height: 300,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 120),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        child: Text(
                                          'Details',
                                          style: AppTextStyles.headlineSmall(context, color: Colors.black).copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                            shadows: [
                                              const Shadow(color: Colors.white, blurRadius: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text('Area',
                                                  style: AppTextStyles.labelSmall(context,
                                                          color: Colors.black.withValues(alpha: 0.5))
                                                      .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text('Measured',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyles.labelSmall(context,
                                                          color: Colors.black.withValues(alpha: 0.5))
                                                      .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text('Ideal',
                                                  textAlign: TextAlign.end,
                                                  style: AppTextStyles.labelSmall(context,
                                                          color: Colors.black.withValues(alpha: 0.5))
                                                      .copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.5),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Builder(builder: (context) {
                                            final List<dynamic> sectionFields =
                                                (widget.sectionJson['fields'] as List<dynamic>? ?? []);
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: List.generate(sectionFields.length, (index) {
                                                final item = sectionFields[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(8),
                                                                  decoration: BoxDecoration(
                                                                      color:
                                                                          appColors.primaryOne.withValues(alpha: 0.1),
                                                                      borderRadius: BorderRadius.circular(12)),
                                                                  child: SizedBox(
                                                                    width: 18,
                                                                    height: 18,
                                                                    child: DynamicIconImage(
                                                                        width: 18,
                                                                        height: 18,
                                                                        imageName: item['name']?.toString() ?? ''),
                                                                  ),
                                                                ),
                                                                const SizedBox(width: 12),
                                                                Expanded(
                                                                    child: Text(item['name']?.toString() ?? '',
                                                                        style: AppTextStyles.bodyMedium(context,
                                                                                color: Colors.black)
                                                                            .copyWith(fontWeight: FontWeight.w600),
                                                                        overflow: TextOverflow.ellipsis)),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: RichText(
                                                              textAlign: TextAlign.center,
                                                              text: TextSpan(children: [
                                                                TextSpan(
                                                                  text: (() {
                                                                    final val = item['value'];
                                                                    if (val == null) return 'NA';
                                                                    double? dVal;
                                                                    if (val is num) {
                                                                      dVal = val.toDouble();
                                                                    } else if (val is String)
                                                                      dVal = double.tryParse(val);
                                                                    return dVal != null
                                                                        ? dVal.toStringAsFixed(1)
                                                                        : val.toString();
                                                                  })(),
                                                                  style: AppTextStyles.bodyMedium(context,
                                                                          color: Colors.black)
                                                                      .copyWith(fontWeight: FontWeight.w900),
                                                                ),
                                                                TextSpan(
                                                                  text: ' ${item['unit']?.toString() ?? ''}',
                                                                  style: AppTextStyles.labelSmall(context,
                                                                      color: Colors.black.withValues(alpha: 0.5)),
                                                                ),
                                                              ]),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(item['range']?.toString() ?? '',
                                                                textAlign: TextAlign.end,
                                                                style: AppTextStyles.bodySmall(context).copyWith(
                                                                    color: Colors.black.withValues(alpha: 0.6),
                                                                    fontWeight: FontWeight.w500)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    if (index < sectionFields.length - 1)
                                                      Divider(
                                                          height: 1,
                                                          thickness: 1,
                                                          indent: 16,
                                                          endIndent: 16,
                                                          color: Colors.black.withValues(alpha: 0.04)),
                                                  ],
                                                );
                                              }),
                                            );
                                          }),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 24),
                                        child: Text(
                                          'Scores',
                                          style: AppTextStyles.titleLarge(context, color: Colors.black),
                                        ),
                                      ),
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.4),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: appColors.alternateTwo.withValues(alpha: .5)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Builder(builder: (context) {
                                              final scoresJson = (widget.sectionJson['scores'] as List<dynamic>?) ?? [];
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: List.generate(scoresJson.length, (index) {
                                                  final scoresJsonItem = scoresJson[index];
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsetsDirectional.fromSTEB(12, 16, 12, 16),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                        width: 25,
                                                                        height: 25,
                                                                        child: DynamicIconImage(
                                                                            width: 25,
                                                                            height: 25,
                                                                            imageName:
                                                                                scoresJsonItem['name']?.toString() ??
                                                                                    '')),
                                                                    Padding(
                                                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                                                          8, 0, 0, 0),
                                                                      child: Text(
                                                                          scoresJsonItem['name']?.toString() ?? '',
                                                                          style: AppTextStyles.bodyMedium(context)
                                                                              .copyWith(fontWeight: FontWeight.bold)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text((() {
                                                                      final val = scoresJsonItem['value'];
                                                                      if (val == null) return 'NA';
                                                                      double? dVal;
                                                                      if (val is num) {
                                                                        dVal = val.toDouble();
                                                                      } else if (val is String)
                                                                        dVal = double.tryParse(val);
                                                                      return dVal != null
                                                                          ? dVal.toStringAsFixed(2)
                                                                          : val.toString();
                                                                    })(),
                                                                        style: AppTextStyles.bodyMedium(context)
                                                                            .copyWith(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: AppThemeManager.primaryText)),
                                                                    const Padding(
                                                                        padding:
                                                                            EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                                                        child: SizedBox(
                                                                            width: 20,
                                                                            height: 20,
                                                                            child: DynamicIconImage(
                                                                                width: 20,
                                                                                height: 20,
                                                                                imageName: 'star'))),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                          color: AppThemeManager.primaryBackground
                                                                              .withValues(alpha: .5),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                          border: Border.all(
                                                                              color: appColors.altContBorders
                                                                                  .withValues(alpha: .5))),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(12),
                                                                        child: Text(
                                                                            'Some feedback to download or I don\'t know how to gather',
                                                                            textAlign: TextAlign.start,
                                                                            style: AppTextStyles.bodySmall(context)
                                                                                .copyWith(fontStyle: FontStyle.italic)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (index < scoresJson.length - 1)
                                                        Divider(
                                                            height: 1,
                                                            thickness: 1,
                                                            indent: 12,
                                                            endIndent: 12,
                                                            color: appColors.alternateTwo.withValues(alpha: .3)),
                                                    ],
                                                  );
                                                }),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
