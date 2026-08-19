import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:swish_lab/constants.dart';
import 'package:swish_lab/controllers/dropdown_controller.dart';
import 'package:swish_lab/functions/process_analysis_results.dart';
import 'package:swish_lab/models/video_source.dart';
import 'package:swish_lab/styles/styles.dart';
import 'package:swish_lab/styles/theme_manager.dart';
import 'package:swish_lab/widgets/app_bar.dart';
import 'package:swish_lab/widgets/background.dart';
import 'package:swish_lab/widgets/box_with_shadow.dart';
import 'package:swish_lab/widgets/custom_text_span.dart';
import 'package:swish_lab/widgets/dark_button.dart';
import 'package:swish_lab/widgets/debug_item.dart';
import 'package:swish_lab/widgets/drop_down.dart';
import 'package:swish_lab/widgets/dynamic_asset.dart';
import 'package:swish_lab/widgets/dynamic_icon_image.dart';
import 'package:swish_lab/widgets/faq_item.dart';
import 'package:swish_lab/widgets/icon_action_button.dart';
import 'package:swish_lab/widgets/input_field.dart';
import 'package:swish_lab/widgets/light_button.dart';
import 'package:swish_lab/widgets/nav_bar.dart';
import 'package:swish_lab/widgets/section_details.dart';
import 'package:swish_lab/widgets/settings_item.dart';
import 'package:swish_lab/widgets/settings_row.dart';
import 'package:swish_lab/widgets/single_choice_chip.dart';
import 'package:swish_lab/widgets/social_icon_button.dart';
import 'package:swish_lab/widgets/stats_container.dart';
import 'package:swish_lab/widgets/toggle_icon.dart';
import 'package:swish_lab/widgets/transparent_button.dart';
import 'package:swish_lab/widgets/video_preview.dart';
import 'package:swish_lab/pages/theme_test_page.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'DarkButton', type: DarkButton)
Widget buildDarkButton(BuildContext context) {
  return DarkButton(onPressed: () {}, text: 'Sample');
}

@widgetbook.UseCase(name: 'LightButton', type: LightButton)
Widget buildLightButton(BuildContext context) {
  return LightButton(
      text: 'Example',
      icon: FaIcon(FontAwesomeIcons.google, size: 15),
      onPressed: () async {});
}

@widgetbook.UseCase(name: 'TransparentButton', type: TransparentButton)
Widget buildTransparentButton(BuildContext context) {
  return TransparentButton(onPressed: () {}, text: 'Sample');
}

// TODO: check appearance in the real app: here it shows a square background on its own
@widgetbook.UseCase(name: 'IconActionButton', type: IconActionButton)
Widget buildIconActionButton(BuildContext context) {
  return IconActionButton(
    const Icon(Icons.paypal),
    borderRadius: 30,
    iconSize: 30,
    onPressed: () async {},
  );
}

@widgetbook.UseCase(name: 'SingleChoiceChip', type: SingleChoiceChip)
Widget buildSingleChoiceChip(BuildContext context) {
  final isSelected =
  context.knobs.boolean(label: 'Selected', initialValue: false);

  return SingleChoiceChip(
      label: 'Sample',
      icon: Icons.paypal,
      selected: isSelected,
      onTap: () async {});
}

@widgetbook.UseCase(name: 'Dropdown', type: Dropdown)
Widget buildDropdown(BuildContext context) {
  return Dropdown<String>(
    controller: DropdownController<String>(),
    options: ['Left', 'Right'],
    onChanged: (_) {},
    hintText: 'Sample sample sample',
  );
}

@widgetbook.UseCase(name: 'SocialIconButton', type: SocialIconButton)
Widget buildSocialIconButton(BuildContext context) {
  return SocialIconButton(const FaIcon(FontAwesomeIcons.twitter), onTap: () {});
}

@widgetbook.UseCase(name: 'ToggleIcon', type: ToggleIcon)
Widget buildToggleIcon(BuildContext context) {
  return ToggleIcon(
    onPressed: () {},
    value: true,
    onIcon: Icon(Icons.search, size: 30),
    offIcon: Icon(Icons.search_off, size: 30),
  );
}

@widgetbook.UseCase(name: 'Text', type: Text)
Widget buildText(BuildContext context) {
  return ValueListenableBuilder(
      valueListenable: AppThemeManager.notifier,
      builder: (_, _, _) {
        return Container(
            color: AppThemeManager.primaryBackground,
            child: Text('some text', style: AppTextStyles.bodyMedium(context)));
      });
}

@widgetbook.UseCase(name: 'CustomTextSpan', type: CustomTextSpan)
Widget buildCustomTextSpan(BuildContext context) {
  return RichText(
      text:
      CustomTextSpan(context, text: 'Sample', style: TextStyle(height: 2)));
}

@widgetbook.UseCase(name: 'InputField', type: InputField)
Widget buildInputField(BuildContext context) {
  return InputField(
      controller: TextEditingController(), onChanged: (_) {}, label: 'Sample');
}

@widgetbook.UseCase(name: 'SettingsRow', type: SettingsRow)
Widget buildSettingsRow(BuildContext context) {
  final backgroundIndex = context.knobs.object.dropdown<int>(
    label: 'Background',
    options: [0, 1, 2],
    initialOption: 0,
    labelBuilder: (value) => 'Variant $value',
  );

  return SettingsRow(
    item: SettingsItem(
        title: 'Sample',
        background: settingsItemBackgrounds[backgroundIndex],
        onTap: (_) async {}),
  );
}

@widgetbook.UseCase(name: 'VideoPreview', type: VideoPreview)
Widget buildVideoPreview(BuildContext context) {
  return VideoPreview(
    source: NetworkVideoSource(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
    autoPlay: false,
  );
}

// TODO: check appearance in the real app: here it shows a square background on its own
@widgetbook.UseCase(name: 'DynamicIconImage', type: DynamicIconImage)
Widget buildDynamicIconImage(BuildContext context) {
  return DynamicIconImage(width: 25, height: 25, imageName: 'default_icon');
}

@widgetbook.UseCase(name: 'DynamicAsset', type: DynamicAsset)
Widget buildDynamicAssetAnimation(BuildContext context) {
  final Map<String, String> objects = {
    'gif': 'loader_basketball.gif',
    'image': 'thompson_front.jpg',
    'icon': 'default_icon.png',
  };
  final assetType = context.knobs.object.dropdown<String>(
    label: 'Asset type',
    options: ["gif", "image", "icon"],
    initialOption: "gif",
    labelBuilder: (value) => value,
  );
  return DynamicAsset(
      width: 200, height: 200, name: objects[assetType]!, type: assetType);
}

@widgetbook.UseCase(name: 'NavBar', type: NavBar)
Widget buildNavBar(BuildContext context) {
  final index = context.knobs.int
      .slider(label: 'Active tab', initialValue: 0, min: 0, max: 3);

  return NavBarView(
    currentIndex: index,
    onTap: null, // static preview
    child: const Center(child: Text('Sample')),
  );
}

@widgetbook.UseCase(name: 'MyAppBar', type: MyAppBar)
Widget buildMyAppBarTitleOnly(BuildContext context) {
  final appbarType = context.knobs.object.dropdown<MyAppBarStyle>(
    label: 'Asset type',
    options: [
      MyAppBarStyle.titleOnly,
      MyAppBarStyle.titleWithProfileImage,
      MyAppBarStyle.backButtonTitleLeft,
      MyAppBarStyle.backButtonTitleCentered
    ],
    initialOption: MyAppBarStyle.titleOnly,
    labelBuilder: (value) => value.name,
  );

  if (appbarType == MyAppBarStyle.titleWithProfileImage) {
    return Scaffold(
      appBar: MyAppBar(
        style: appbarType,
        title: 'Sample',
        height: 100,
        onProfilePressed: () {},
        profileImageUrl:
        'https://yavuzceliker.github.io/sample-images/image-1021.jpg',
      ),
      body: Center(child: Text('Body content here')),
    );
  }

  return Scaffold(
    appBar: MyAppBar(style: appbarType, title: 'Sample'),
    body: Center(child: Text('Body content here')),
  );
}

@widgetbook.UseCase(name: 'Background', type: Background)
Widget buildBackground(BuildContext context) {
  return Center(
    child: Background(
      child: SizedBox(width: double.infinity, height: double.infinity),
    ),
  );
}

@widgetbook.UseCase(name: 'BoxWithShadow', type: BoxWithShadow)
Widget buildBoxWithShadow(BuildContext context) {
  final List<Color> borderColors = [
    AppThemeManager.currentColors.containersBorders,
    AppThemeManager.currentColors.altContBorders,
  ];
  final borderIndex = context.knobs.object.dropdown<int>(
    label: 'Border color',
    options: [0, 1],
    initialOption: 0,
    labelBuilder: (value) => 'Variant $value',
  );

  return Container(
      color: AppThemeManager.primaryBackground,
      child: Center(
          child: Container(
              width: 200,
              height: 200,
              decoration: BoxWithShadow(
                  border: Border.all(color: borderColors[borderIndex])))));
}

@widgetbook.UseCase(name: 'StatsContainer', type: StatsContainer)
Widget buildStatsContainer(BuildContext context) {
  final appColors = AppThemeManager.currentColors;
  return StatsContainer(
      borderColor: appColors.alternateTwo,
      title: 'Sample',
      iconName: 'jump',
      text: 'Sample1');
}

@widgetbook.UseCase(name: 'FaqItem', type: FaqItem)
Widget buildFaqItem(BuildContext context) {
  final isOpen = context.knobs.boolean(label: 'Open', initialValue: false);

  return FaqItem(
    key: const Key('faq_sample'),
    isOpen: isOpen,
    title: 'Sample question',
    description: 'Sample description',
    onPressed: () async {},
  );
}

@widgetbook.UseCase(name: 'DebugItem', type: DebugItem)
Widget buildDebugItem(BuildContext context) {
  return DebugItem(
      width: 300,
      title: 'Sample Utility',
      subtitle: 'This is a subtitle for the utility',
      icon: Icons.bug_report_rounded,
      buttonText: 'Action',
      onPressed: () async {});
}

@widgetbook.UseCase(name: 'SectionDetails', type: SectionDetails)
Widget buildSectionDetails(BuildContext context) {
  return SectionDetails(
      sectionJson: processAnalysisResults(
          jsonDecode(kDefaultResultsJson)["analysis"])[0]);
}

@widgetbook.UseCase(name: 'Theme Color Test', type: ThemeTestPage)
Widget buildThemeTestPage(BuildContext context) {
  return const ThemeTestPage();
}
