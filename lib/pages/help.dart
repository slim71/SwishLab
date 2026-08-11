import 'dart:convert';
import 'dart:ui' as ui;

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../functions/add_animation.dart';
import '../functions/filter_faqs.dart';
import '../functions/sort_by_order.dart';
import '../logger.dart';
import '../state/app_state.dart';
import '../styles/styles.dart';
import '../styles/theme_manager.dart';
import '../widgets/app_bar.dart';
import '../widgets/background.dart';
import '../widgets/dark_button.dart';
import '../widgets/faq_item.dart';
import '../widgets/input_field.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> with TickerProviderStateMixin {
  static final _logger = AppLogger.scope('HelpPage');
  int? openIndex = -1;
  String faqSearchQuery = '';
  bool searchActive = false;

  FocusNode? searchFieldFocusNode;
  late final TextEditingController searchFieldTextController;

  @override
  void initState() {
    super.initState();
    searchFieldTextController = TextEditingController();
    searchFieldFocusNode = FocusNode();
  }

  @override
  void dispose() {
    searchFieldTextController.dispose();
    searchFieldFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppThemeManager.currentColors;

    // Watch the FAQs from state
    var allFaqs = ref.watch(appStateProvider.select((s) => s.loadedFaqs)) ?? [];

    _logger.d('Initial FAQs from state: ${allFaqs.length}');

    // Emergency Fallback: If state is empty, try parsing the default JSON directly
    if (allFaqs.isEmpty) {
      try {
        allFaqs = (json.decode(kDefaultFaqsJson) as List).cast<Map<String, dynamic>>();
        _logger.d('Using fallback FAQs: ${allFaqs.length}');
      } catch (e) {
        _logger.e('Fallback parse error: $e');
      }
    }

    // Filter based on search query
    final filtered = filterFaqs(allFaqs, faqSearchQuery);
    _logger.d('Filtered count for "$faqSearchQuery": ${filtered.length}');

    // Sort the results
    final faqsList = sortByOrder(filtered);
    _logger.d('Final sorted list count: ${faqsList.length}');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: const MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'Help',
        ),
        body: SafeArea(
          top: true,
          child: Background(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Glass Header
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppThemeManager.secondaryBackground.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'How can we help you?',
                                          style:
                                              AppTextStyles.headlineMedium(context, color: AppThemeManager.primaryText),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Find answers to common questions or reach out to our support team.',
                                          style: AppTextStyles.bodyMedium(context,
                                              color: AppThemeManager.primaryText.withValues(alpha: 0.7)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Action Buttons Row
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: addAnimation(
                                  widget: DarkButton(
                                    onPressed: () async {
                                      final Uri emailUri = Uri(
                                        scheme: 'mailto',
                                        path: 'slim71sv@gmail.com',
                                        query: {
                                          'subject': 'SwishLab Support',
                                          'body': 'Hi, I need help with...',
                                        }
                                            .entries
                                            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                            .join('&'),
                                      );

                                      try {
                                        if (await canLaunchUrl(emailUri)) {
                                          await launchUrl(emailUri);
                                        } else {
                                          throw 'Could not launch email app';
                                        }
                                      } catch (e) {
                                        _logger.e('Error launching email: $e');
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('No email app found on this device.'),
                                              duration: Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    text: 'Email Us',
                                    height: 60,
                                    borderRadius: 16,
                                    icon: const Icon(Icons.email_rounded, size: 28),
                                  ),
                                  move: const MoveConfig(begin: Offset(0, 30)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: addAnimation(
                                  widget: DarkButton(
                                    onPressed: () {
                                      setState(() {
                                        searchActive = !searchActive;
                                        if (!searchActive) {
                                          searchFieldTextController.clear();
                                          faqSearchQuery = '';
                                        } else {
                                          searchFieldFocusNode?.requestFocus();
                                        }
                                      });
                                    },
                                    text: 'Search',
                                    height: 60,
                                    borderRadius: 16,
                                    iconValue: searchActive,
                                    onIcon: Icon(
                                      Icons.search_rounded,
                                      color: appColors.darkButtonTextColor,
                                      size: 28,
                                    ),
                                    offIcon: Icon(
                                      Icons.search_off_rounded,
                                      color: appColors.darkButtonTextColor,
                                      size: 28,
                                    ),
                                  ),
                                  move: const MoveConfig(begin: Offset(0, 30)),
                                ),
                              ),
                            ],
                          ),

                          // Search Bar Visibility
                          if (searchActive)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: addAnimation(
                                widget: InputField(
                                  controller: searchFieldTextController,
                                  focusNode: searchFieldFocusNode,
                                  label: 'Search filter',
                                  onChanged: (value) {
                                    _logger.d('onChanged triggered with: $value');
                                    EasyDebounce.debounce(
                                      'helpSearchDebounce',
                                      const Duration(milliseconds: 200),
                                      () {
                                        if (mounted) {
                                          _logger.d('Setting search query state: $value');
                                          setState(() {
                                            faqSearchQuery = value;
                                            openIndex = -1;
                                          });
                                        }
                                      },
                                    );
                                  },
                                  textCapitalization: TextCapitalization.none,
                                  denyRegex: RegExp(r'[\x00-\x1F\x7F]'),
                                ),
                                move: const MoveConfig(begin: Offset(0, -20)),
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 24, 0, 12),
                            child: Text(
                              'Frequently Asked Questions',
                              style: AppTextStyles.headlineSmall(context, color: AppThemeManager.primaryText),
                            ),
                          ),

                          // List items
                          if (faqsList.isEmpty)
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Text(
                                'No results found.',
                                style: AppTextStyles.titleLarge(context),
                              ),
                            )
                          else
                            Column(
                              children: List.generate(faqsList.length, (index) {
                                final item = faqsList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: FaqItem(
                                    key: ValueKey(item['question']),
                                    isOpen: openIndex == index,
                                    title: item['question'].toString(),
                                    description: item['answer'].toString(),
                                    onPressed: () async {
                                      setState(() {
                                        openIndex = openIndex == index ? -1 : index;
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
