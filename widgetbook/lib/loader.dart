import 'dart:convert';

import 'package:SwishLab/functions/process_analysis_results.dart';
import 'package:flutter/material.dart';
import 'package:SwishLab/widgets/icon_action_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';
import 'package:SwishLab/constants.dart';
import 'package:SwishLab/controllers/dropdown_controller.dart';
import 'package:SwishLab/models/video_source.dart';
import 'package:SwishLab/styles/theme_manager.dart';
import 'package:SwishLab/widgets/app_bar.dart';
import 'package:SwishLab/widgets/background.dart';
import 'package:SwishLab/widgets/box_with_shadow.dart';
import 'package:SwishLab/widgets/custom_text_span.dart';
import 'package:SwishLab/widgets/dark_button.dart';
import 'package:SwishLab/widgets/debug_item.dart';
import 'package:SwishLab/widgets/drop_down.dart';
import 'package:SwishLab/widgets/dynamic_asset.dart';
import 'package:SwishLab/widgets/dynamic_icon_image.dart';
import 'package:SwishLab/widgets/faq_item.dart';
import 'package:SwishLab/widgets/input_field.dart';
import 'package:SwishLab/widgets/light_button.dart';
import 'package:SwishLab/widgets/nav_bar.dart';
import 'package:SwishLab/widgets/section_details.dart';
import 'package:SwishLab/widgets/settings_item.dart';
import 'package:SwishLab/widgets/settings_row.dart';
import 'package:SwishLab/widgets/single_choice_chip.dart';
import 'package:SwishLab/widgets/social_icon_button.dart';
import 'package:SwishLab/widgets/stats_container.dart';
import 'package:SwishLab/widgets/toggle_icon.dart';
import 'package:SwishLab/widgets/transparent_button.dart';
import 'package:SwishLab/widgets/video_preview.dart';

@widgetbook.UseCase(
  name: 'IconActionButton',
  type: IconActionButton,
) // TODO: retest once brightness is separated from colorset
Widget buildIconActionButton(BuildContext context) {
  return Center(
    child: IconActionButton(
      borderColor: Colors.transparent,
      borderRadius: 30,
      borderWidth: 1,
      size: 50,
      icon: Icons.paypal,
      iconSize: 30,
      onPressed: () async {},
    ),
  );
}

@widgetbook.UseCase(name: 'LightButton', type: LightButton)
Widget buildLightButton(BuildContext context) {
  return Center(
    child: LightButton(text: 'Example', icon: FaIcon(FontAwesomeIcons.google, size: 15), onPressed: () async {}),
  );
}

@widgetbook.UseCase(name: 'SingleChoiceChip', type: SingleChoiceChip)
Widget buildSingleChoiceChip(BuildContext context) {
  final isSelected = context.knobs.boolean(label: 'Selected', initialValue: false);

  return Center(
    child: SingleChoiceChip(label: 'Sample', icon: Icons.paypal, selected: isSelected, onTap: () async {}),
  );
}

@widgetbook.UseCase(name: 'SocialIconButton', type: SocialIconButton)
Widget buildSocialIconButton(BuildContext context) {
  return Center(
    child: SocialIconButton(icon: FontAwesomeIcons.twitter, onTap: () {}),
  );
}

@widgetbook.UseCase(name: 'ToggleIcon', type: ToggleIcon)
Widget buildToggleIcon(BuildContext context) {
  return Center(
    child: ToggleIcon(
      onPressed: () {},
      value: true,
      onIcon: Icon(Icons.search, size: 30),
      offIcon: Icon(Icons.search_off, size: 30),
    ),
  );
}

@widgetbook.UseCase(name: 'TransparentButton', type: TransparentButton)
Widget buildTransparentButton(BuildContext context) {
  return Center(
    child: TransparentButton(onPressed: () {}, text: 'Sample'),
  );
}

@widgetbook.UseCase(name: 'DarkButton', type: DarkButton)
Widget buildDarkButton(BuildContext context) {
  return Center(
    child: DarkButton(onPressed: () {}, text: 'Sample'),
  );
}

@widgetbook.UseCase(name: 'Dropdown', type: Dropdown)
Widget buildDropdown(BuildContext context) {
  return Center(
    child: Dropdown<String>(
      controller: DropdownController<String>(),
      options: ['Left', 'Right'],
      onChanged: (_) {},
      hintText: 'Sample sample sample',
    ),
  );
}

@widgetbook.UseCase(name: 'Text', type: Text)
Widget buildText(BuildContext context) {
  return Center(child: Text('some text', style: Theme.of(context).textTheme.bodyMedium));
}

@widgetbook.UseCase(
  name: 'CustomTextSpan',
  type: CustomTextSpan,
) // TODO: retest once brightness is separated from colorset
Widget buildCustomTextSpan(BuildContext context) {
  return Center(
    child: RichText(text: CustomTextSpan(text: 'Sample')),
  );
}

@widgetbook.UseCase(name: 'InputField', type: InputField)
Widget buildInputField(BuildContext context) {
  return Center(
    child: InputField(controller: TextEditingController(), onChanged: (_) {}, label: 'Sample'),
  );
}

@widgetbook.UseCase(name: 'VideoPreview', type: VideoPreview)
Widget buildVideoPreview(BuildContext context) {
  return Center(
    child: VideoPreview(
      source: NetworkVideoSource('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      autoPlay: false,
    ),
  );
}

@widgetbook.UseCase(name: 'DynamicIconImage', type: DynamicIconImage)
Widget buildDynamicIconImage(BuildContext context) {
  return Center(child: DynamicIconImage(width: 25, height: 25, imageName: 'default_icon'));
}

@widgetbook.UseCase(name: 'DynamicAsset-Animation', type: DynamicAsset)
Widget buildDynamicAssetAnimation(BuildContext context) {
  return Center(
    child: DynamicAsset(width: 200, height: 200, name: "loader_basketball.json", type: "animation"),
  );
}

@widgetbook.UseCase(name: 'DynamicAsset-Image', type: DynamicAsset)
Widget buildDynamicAssetImage(BuildContext context) {
  return Center(
    child: DynamicAsset(width: 200, height: 200, name: "thompson_front.jpg", type: "image"),
  );
}

@widgetbook.UseCase(name: 'DynamicAsset-Gif', type: DynamicAsset)
Widget buildDynamicAssetGif(BuildContext context) {
  return Center(
    child: DynamicAsset(width: 200, height: 200, name: "thompson.gif", type: "gif"),
  );
}

@widgetbook.UseCase(name: 'DynamicAsset-Icon', type: DynamicAsset)
Widget buildDynamicAssetIcon(BuildContext context) {
  return Center(
    child: DynamicAsset(width: 200, height: 200, name: "default_icon.png", type: "icon"),
  );
}

@widgetbook.UseCase(name: 'NavBar', type: NavBar)
Widget buildNavBar(BuildContext context) {
  final index = context.knobs.int.slider(label: 'Active tab', initialValue: 0, min: 0, max: 3);

  return NavBarView(
    currentIndex: index,
    onTap: null, // static preview
    child: const Center(child: Text('Sample')),
  );
}

@widgetbook.UseCase(name: 'MyAppBar-TitleOnly', type: MyAppBar)
Widget buildMyAppBarTitleOnly(BuildContext context) {
  return Scaffold(
    appBar: MyAppBar(style: MyAppBarStyle.titleOnly, title: 'Past activity'),
    body: Center(child: Text('Body content here')),
  );
}

@widgetbook.UseCase(name: 'MyAppBar-TitleWithProfileImage', type: MyAppBar)
Widget buildMyAppBarTitleWithProfileImage(BuildContext context) {
  return Scaffold(
    appBar: MyAppBar(
      style: MyAppBarStyle.titleWithProfileImage,
      title: 'Sample',
      height: 100,
      onProfilePressed: () {},
      profileImageUrl: 'https://yavuzceliker.github.io/sample-images/image-1021.jpg',
    ),
    body: Center(child: Text('Body content here')),
  );
}

@widgetbook.UseCase(name: 'MyAppBar-BackButtonTitleLeft', type: MyAppBar)
Widget buildMyAppBarBackButtonTitleLeft(BuildContext context) {
  return Scaffold(
    appBar: MyAppBar(style: MyAppBarStyle.backButtonTitleLeft, title: 'Sample'),
    body: Center(child: Text('Body content here')),
  );
}

@widgetbook.UseCase(name: 'MyAppBar-BackButtonTitleCentered', type: MyAppBar)
Widget buildMyAppBarBackButtonTitleCentered(BuildContext context) {
  return Scaffold(
    appBar: MyAppBar(style: MyAppBarStyle.backButtonTitleCentered, title: 'Sample'),
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

@widgetbook.UseCase(
  name: 'BoxWithShadow',
  type: BoxWithShadow,
) // TODO: retest once brightness is separated from colorset
Widget buildBoxWithShadow(BuildContext context) {
  return Center(child: Container(width: 200, height: 200, decoration: BoxWithShadow()));
}

@widgetbook.UseCase(name: 'BoxWithShadow-Color', type: BoxWithShadow)
Widget buildBoxWithShadowColor(BuildContext context) {
  final appColors = AppThemeManager.currentColors;
  return Center(
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxWithShadow(border: Border.all(color: appColors.containersBorders)),
    ),
  );
}

@widgetbook.UseCase(name: 'BoxWithShadow-Alternate', type: BoxWithShadow)
Widget buildBoxWithShadowAlternate(BuildContext context) {
  final appColors = AppThemeManager.currentColors;
  return Center(
    child: Container(
      width: 200,
      height: 200,
      decoration: BoxWithShadow(border: Border.all(color: appColors.altContBorders)),
    ),
  );
}

@widgetbook.UseCase(name: 'StatsContainer', type: StatsContainer)
Widget buildStatsContainer(BuildContext context) {
  final appColors = AppThemeManager.currentColors;
  return Center(
    child: StatsContainer(borderColor: appColors.alternateTwo, title: 'Sample', iconName: 'jump', text: 'Sample1'),
  );
}

@widgetbook.UseCase(name: 'FaqItem', type: FaqItem)
Widget buildFaqItem(BuildContext context) {
  final isOpen = context.knobs.boolean(label: 'Open', initialValue: false);

  return Center(
    child: FaqItem(
      key: const Key('faq_sample'),
      isOpen: isOpen,
      title: 'Sample question',
      description: 'Sample description',
      onPressed: () async {},
    ),
  );
}

@widgetbook.UseCase(name: 'DebugItem', type: DebugItem) // TODO: retest once brightness is separated from colorset
Widget buildDebugItem(BuildContext context) {
  return Center(
    child: DebugItem(width: 300, title: 'Sample', buttonText: 'Sample', onPressed: () async {}),
  );
}

@widgetbook.UseCase(name: 'SettingsRow', type: SettingsRow)
Widget buildSettingsRow(BuildContext context) {
  final backgroundIndex = context.knobs.object.dropdown<int>(
    label: 'Background',
    options: [0, 1, 2],
    initialOption: 0,
    labelBuilder: (value) => 'Variant $value',
  );

  return Center(
    child: SettingsRow(
      item: SettingsItem(title: 'Sample', background: settingsItemBackgrounds[backgroundIndex], onTap: (_) async {}),
    ),
  );
}

@widgetbook.UseCase(name: 'SectionDetails', type: SectionDetails)
Widget buildSectionDetails(BuildContext context) {
  return Center(
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      width: 400,
      child: SectionDetails(sectionJson: processAnalysisResults(jsonDecode(kDefaultResultsJson)["analysis"])[0]),
    ),
  );
}
