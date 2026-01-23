import 'package:SwishLab/functions/filter_faqs.dart';
import 'package:SwishLab/functions/sort_by_order.dart';
import 'package:SwishLab/state/app_state.dart';
import 'package:SwishLab/styles/styles.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/faq_item.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:SwishLab/widgets/toggle_icon.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends ConsumerStatefulWidget {
  const HelpPage({super.key});

  @override
  ConsumerState<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends ConsumerState<HelpPage> with TickerProviderStateMixin {
  /// Index of the currently opened FAQ
  int? openIndex = -1;

  /// Filter to apply to the search
  String? faqSearchQuery;

  /// Page State to show the search bar
  bool searchActive = false;

  /// List of FAQs properly filtered through the search field
  List<dynamic> filteredFaqsPageState = [];

  void addToFilteredFaqsPageState(dynamic item) => filteredFaqsPageState.add(item);

  void removeFromFilteredFaqsPageState(dynamic item) => filteredFaqsPageState.remove(item);

  void removeAtIndexFromFilteredFaqsPageState(int index) => filteredFaqsPageState.removeAt(index);

  void insertAtIndexInFilteredFaqsPageState(int index, dynamic item) => filteredFaqsPageState.insert(index, item);

  void updateFilteredFaqsPageStateAtIndex(int index, Function(dynamic) updateFn) =>
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
    final appState = ref.watch(appStateProvider);

    // Start with all FAQs
    filteredFaqsPageState = appState.loadedFaqs!.toList();

    // Apply filter asynchronously
    if (faqSearchQuery != null && faqSearchQuery!.isNotEmpty) {
      _filterFaqs();
    }
    searchFieldTextController = TextEditingController();
    searchFieldFocusNode ??= FocusNode();
  }

  Future<void> _filterFaqs() async {
    final appState = ref.watch(appStateProvider);
    final filtered = await filterFaqs(
      appState.loadedFaqs!.toList(),
      faqSearchQuery!,
    );
    filteredFaqsPageState = filtered.toList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appStateProvider);
    final appColors = AppThemeManager.currentColors;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: MyAppBar(
          style: MyAppBarStyle.backButtonTitleLeft,
          title: 'Help',
        ),
        body: SafeArea(
          top: true,
          child:
              // Background container
              Semantics(
            label: 'Background container',
                  child: Background(
                    child: Semantics(
                      label: 'Main content column',
                child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Column used to scroll the page
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                              child: Semantics(
                                label: 'Scrolling column',
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // "How can we help you?" text
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                        child: Semantics(
                                          label: '"How can we help you?" text',
                                          child: Text(
                                            'How can we help you?',
                                            style: AppTextStyles.headlineMedium(),
                                          ),
                                        ),
                                      ),

                                      // Row to place the functionality widgets
                                Semantics(
                                  label: 'Functionality widgets row',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      // Button to send an email
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                        child: Semantics(
                                          label: 'Button to send an email',
                                          child: DarkButton(
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
                                            icon: Icon(
                                              Icons.email,
                                              size: 30,
                                            ), // TODO: what about the size?
                                          ),
                                        )
                                            .animate()
                                            .fade(
                                          begin: 0,
                                          end: 1,
                                          duration: 600.ms,
                                          curve: Curves.easeInOut,
                                        )
                                            .move(
                                          begin: const Offset(0, 110),
                                          end: Offset.zero,
                                          duration: 600.ms,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Container to simulate a button for the search filter
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                          child: Semantics(
                                            label: 'Search button container',
                                            child: InkWell(
                                              onTap: () async {
                                                // Immediate UI state changes
                                                setState(() {
                                                  searchActive = !searchActive;
                                                  searchFieldTextController.clear();
                                                  faqSearchQuery = '';
                                                });

                                                      // Delay
                                                      await Future.delayed(Duration(milliseconds: 300));
                                                      if (!mounted) return;

                                                      // Async computation
                                                final result = await filterFaqs(
                                                  appState.loadedFaqs!.toList(),
                                                  faqSearchQuery!,
                                                );
                                                if (!mounted) return;

                                                      // Apply result
                                                      setState(() {
                                                        filteredFaqsActionContainer = result;
                                                        filteredFaqsPageState = result.toList().cast<dynamic>();
                                                      });
                                                    },
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      elevation: 10,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Container(
                                                        width: 190,
                                                        height: 80,
                                                        constraints: BoxConstraints(
                                                          maxWidth: 500,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: appColors.darkButtonBackground,
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(
                                                            color: appColors.darkButtonBorders,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child:
                                                            // Column to place the search button content
                                                            Semantics(
                                                          label: 'Search button content column',
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.max,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              // Column to place the search button content
                                                              Semantics(
                                                                label: 'Search button content row',
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    // Toggle search icon
                                                                    Semantics(
                                                                      label: 'Toggle search icon',
                                                                      child: ToggleIcon(
                                                                        onPressed: () {
                                                                          setState(() {
                                                                            searchActive = !searchActive;
                                                                          });
                                                                        },
                                                                        value: searchActive,
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
                                                                    ),

                                                                    // "Search FAQs" text
                                                              Semantics(
                                                                label: '"Search FAQs" text',
                                                                child: Text(
                                                                  'Search FAQs',
                                                                  textAlign: TextAlign.center,
                                                                  style: AppTextStyles.titleLarge(
                                                                      color: appColors.darkButtonTextColor),
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
                                            ),
                                          )
                                              .animate()
                                              .fade(
                                            begin: 0,
                                            end: 1,
                                            duration: 600.ms,
                                            curve: Curves.easeInOut,
                                          )
                                              .move(
                                            begin: const Offset(0, 110),
                                            end: Offset.zero,
                                            duration: 600.ms,
                                            curve: Curves.easeInOut,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                      // Row to put the search bar into
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                        child: Semantics(
                                          label: 'Search bar row',
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // Container to put the search bar into
                                              Expanded(
                                                child: Semantics(
                                                  label: 'Search bar container',
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child:
                                                        // Search bar input field
                                                        Visibility(
                                                      visible: searchActive,
                                                      child: Padding(
                                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                                                        child: Semantics(
                                                          label: 'Search bar input field',
                                                          child: InputField(
                                                            controller: searchFieldTextController,
                                                            focusNode: searchFieldFocusNode,
                                                            onChanged: (_) => EasyDebounce.debounce(
                                                              'searchFieldTextController',
                                                              const Duration(milliseconds: 2000),
                                                              () async {
                                                                if (!mounted) return;

                                                                await Future.delayed(
                                                                Duration(
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
                                                                  appState.loadedFaqs!.toList(),
                                                                  faqSearchQuery!,
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                      // "Frequently Asked Questions" text
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                                        child: Semantics(
                                          label: '"Frequently Asked Questions" text',
                                          child: Text(
                                            'Frequently Asked Questions',
                                            style: AppTextStyles.headlineSmall(),
                                          ),
                                        ),
                                      ),

                                      // "No results found." text
                                if (!(filteredFaqsPageState.isNotEmpty))
                                  Semantics(
                                    label: '"No results found." text',
                                    child: Text(
                                      'No results found.',
                                      style: AppTextStyles.titleLarge(),
                                    ),
                                  ),

                                      // Wrap containing all FAQs
                                      Builder(
                                        builder: (context) {
                                          final faqsList = sortByOrder(filteredFaqsPageState.toList()).toList();

                                          return Semantics(
                                      label: 'FAQs wrap',
                                      child: Wrap(
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
                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                              child: Semantics(
                                                label: 'FAQ item',
                                                child: FaqItem(
                                                  key: Key('faq_$faqsListIndex'),
                                                  isOpen: openIndex == faqsListIndex,
                                                  title: faqsListItem['question'].toString(),
                                                  description: faqsListItem['answer'].toString(),
                                                  onPressed: () async {
                                                    setState(() {
                                                      openIndex = openIndex == faqsListIndex ? -1 : faqsListIndex;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                        }),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                  )),
        ),
      ),
    );
  }
}
