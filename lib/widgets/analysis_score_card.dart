import 'dart:ui';
import 'package:flutter/material.dart';
import '../functions/get_border_color.dart';
import '../functions/score_to_rating.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import 'box_with_shadow.dart';
import 'dynamic_icon_image.dart';
import 'section_details.dart';

/// A card that displays the score and rating for a specific analysis section.
class AnalysisScoreCard extends StatelessWidget {
  final Map<String, dynamic> sectionData;
  final int index;
  final List<Color> borderColors;

  const AnalysisScoreCard({
    super.key,
    required this.sectionData,
    required this.index,
    required this.borderColors,
  });

  @override
  Widget build(BuildContext context) {
    final sectionName = sectionData['section'].toString();
    final scores = sectionData['scores'] as List?;
    final totalScoreMap = scores?.firstWhere(
      (e) => e['name'] == 'Total',
      orElse: () => <String, dynamic>{},
    );
    final scoreValue = (totalScoreMap?['value'] as num?)?.toDouble() ?? 0.0;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: (MediaQuery.sizeOf(context).width - 64) / 2,
            decoration: BoxWithShadow(
              color: AppThemeManager.secondaryBackground.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: getBorderColor(borderColors, index).withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () => _showDetails(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: DynamicIconImage(
                        width: 40,
                        height: 40,
                        imageName: sectionName,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      sectionName,
                      style: AppTextStyles.bodyMedium(context, color: AppThemeManager.primaryText).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      scoreToRating(scoreValue).toUpperCase(),
                      style: AppTextStyles.labelSmall(context, color: AppThemeManager.primaryText).copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: AppThemeManager.primaryText.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      scoreValue.toStringAsFixed(1),
                      style: AppTextStyles.titleLarge(context, color: AppThemeManager.primaryText),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: MediaQuery.viewInsetsOf(context),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: SectionDetails(
                sectionJson: sectionData,
              ),
            ),
          ),
        );
      },
    );
  }
}
