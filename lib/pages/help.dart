import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../functions/add_animation.dart';
import '../functions/filter_faqs.dart';
import '../functions/sort_by_order.dart';
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
  /// Index of the currently opened FAQ
  int? openIndex = -1;

  /// Filter to apply to the search
  String faqSearchQuery = '';

  /// Page State to show the search bar
  bool searchActive = false;

  /// List of FAQs properly filtered through the search field
  List<dynamic> filteredFaqsPageState = [];

  void addToFilteredFaqsPageState(dynamic item) => filteredFaqsPageState.add(item);

  void removeFromFilteredFaqsPageState(dynamic item) => filteredFaqsPageState.remove(item);

  void removeAtIndexFromFilteredFaqsPageState(int index) => filteredFaqsPageState.removeAt(index);

  void insertAtIndexInFilteredFaqsPageState(int index, dynamic item) => filteredFaqsPageState.insert(index, item);

  void updateFilteredFaqsPageStateAtIndex(int index, dynamic Function(dynamic) updateFn) =>
      filteredFaqsPageState[index] = updateFn(filteredFaqsPageState[index]);

  List<dynamic>? filteredFaqsAction;

  List<dynamic>? filteredFaqsActionContainer;

  // State field(s) for searchField widget.
  FocusNode? searchFieldFocusNode;
  late final TextEditingController searchFieldTextController;

  List<dynamic>? filteredFaqsActionOnChange;

  @override
  void initState() {
    super.initState();
    final appState = ref.read(appStateProvider);

    // Start with all FAQs
    filteredFaqsPageState = appState.loadedFaqs?.toList() ?? [];

    // Apply filter asynchronously
    if (faqSearchQuery.isNotEmpty) {
      _filterFaqs();
    }
    searchFieldTextController = TextEditingController();
    searchFieldFocusNode ??= FocusNode();
  }

  Future<void> _filterFaqs() async {
    final appState = ref.read(appStateProvider);
    final faqs = appState.loadedFaqs?.toList() ?? [];
    final filtered = await filterFaqs(
      faqs,
      faqSearchQuery,
    );
    filteredFaqsPageState = filtered.toList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final appColors = AppThemeManager.currentColors;

    // Determine which FAQs to show: either the filtered ones (if searching) or all of them
    final List<dynamic> baseFaqs =
        (searchActive && faqSearchQuery.isNotEmpty) ? filteredFaqsPageState : (appState.loadedFaqs ?? []);

    final faqsList = sortByOrder(baseFaqs.toList()).toList();

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
          child:
              // Background container
              Background(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Column used to scroll the page
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "How can we help you?" text
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Text(
                              'How can we help you?',
                              style: AppTextStyles.headlineMedium(context),
                            ),
                          ),

                          // Row to place the functionality widgets
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Button to send an email
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                child: addAnimation(
                                  widget: DarkButton(
                                    onPressed: () async {
                                      await launchUrl(Uri(
                                          scheme: 'mailto',
                                          path: 'slim71sv@gmail.com',
                                          query: {
                                            'subject': 'Enter the subject',
                                            'body': 'AMA',
                                          }
                                              .entries
                                              .map((MapEntry<String, String> e) =>
                                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                              .join('&')));
                                    },
                                    text: 'Email Us',
                                    height: 60,
                                    icon: const Icon(
                                      Icons.email,
                                      size: 30,
                                    ),
                                  ),
                                  move: const MoveConfig(begin: Offset(0, 110)),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Button to simulate a search filter
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: addAnimation(
                                    widget: DarkButton(
                                      onPressed: () async {
                                        // Immediate UI state changes
                                        setState(() {
                                          searchActive = !searchActive;
                                          searchFieldTextController.clear();
                                          faqSearchQuery = '';
                                        });

                                        // Delay
                                        await Future<void>.delayed(const Duration(milliseconds: 300));
                                        if (!mounted) return;

                                        // Async computation
                                        final result = await filterFaqs(
                                          appState.loadedFaqs?.toList() ?? [],
                                          faqSearchQuery,
                                        );
                                        if (!mounted) return;

                                        // Apply result
                                        setState(() {
                                          filteredFaqsActionContainer = result;
                                          filteredFaqsPageState = result.toList().cast<dynamic>();
                                        });
                                      },
                                      text: 'Search FAQs',
                                      height: 60,
                                      borderRadius: 12,
                                      iconValue: searchActive,
                                      onIcon: Icon(
                                        Icons.search,
                                        color: appColors.darkButtonTextColor,
                                        size: 30,
                                      ),
                                      offIcon: Icon(
                                        Icons.search_off,
                                        color: appColors.darkButtonTextColor,
                                        size: 30,
                                      ),
                                    ),
                                    move: const MoveConfig(begin: Offset(0, 110)),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Row to put the search bar into
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Container to put the search bar into
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child:
                                        // Search bar input field
                                        Visibility(
                                      visible: searchActive,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                        child: InputField(
                                          controller: searchFieldTextController,
                                          focusNode: searchFieldFocusNode,
                                          onChanged: (_) => EasyDebounce.debounce(
                                            'searchFieldTextController',
                                            const Duration(milliseconds: 2000),
                                            () async {
                                              if (!mounted) return;

                                              await Future<void>.delayed(
                                                const Duration(
                                                  milliseconds: 300,
                                                ),
                                              );
                                              // Update the query from the controller
                                              final query = searchFieldTextController.text;
                                              setState(() {
                                                faqSearchQuery = query;
                                              });

                                              // Perform the async filtering
                                              final result = await filterFaqs(
                                                appState.loadedFaqs?.toList() ?? [],
                                                faqSearchQuery,
                                              );
                                              if (!mounted) return;

                                              // Update the filtered list
                                              setState(() {
                                                filteredFaqsActionOnChange = result;
                                                filteredFaqsPageState = result.toList();
                                              });
                                            },
                                          ),
                                          textCapitalization: TextCapitalization.none,
                                          label: 'Search filter',
                                          validator: null,
                                          denyRegex: RegExp(r'[\x00-\x1F\x7F]'), // control characters only
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // "Frequently Asked Questions" text
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                            child: Text(
                              'Frequently Asked Questions',
                              style: AppTextStyles.headlineSmall(context),
                            ),
                          ),

                          // "No results found." text
                          if (!(filteredFaqsPageState.isNotEmpty))
                            Text(
                              'No results found.',
                              style: AppTextStyles.titleLarge(context),
                            ),

                          // Wrap containing all FAQs
                          Wrap(
                            spacing: 0,
                            runSpacing: 0,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: List.generate(faqsList.length, (faqsListIndex) {
                              final faqsListItem = faqsList[faqsListIndex];
                              return
                                  // Dynamically generated item containing each FAQ
                                  Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: FaqItem(
                                  key: ValueKey(faqsListItem['question']),
                                  isOpen: openIndex == faqsListIndex,
                                  title: faqsListItem['question'].toString(),
                                  description: faqsListItem['answer'].toString(),
                                  onPressed: () async {
                                    setState(() {
                                      openIndex = openIndex == faqsListIndex ? -1 : faqsListIndex;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
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
