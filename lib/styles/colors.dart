import 'package:flutter/material.dart';

const royalBlue = Color(0xFF27408B);
const goldenYellow = Color(0xFFFFD300);
const white = Color(0xFFFFFFFF);
const blackWash = Color(0xFF0C0D0C);
const night = Color(0xFF0F1E3D);
const darkerGold = Color(0xFFE2B007);
const persianRed = Color(0xFFD50032);
const marianBlue = Color(0xFF0038A8);
const pictonBlue = Color(0xFF0096FF);
const airForceBlue = Color(0xFF41729F);
const oxfordBlue = Color(0xFF001F4D);
const transparentGold = Color(0x45ffc72c);

const primaryBackgroundLight = Color(0xFFF5F3EE);
const secondaryBackgroundLight = Color(0xFFFFFFFF);
const primaryBackgroundDark = Color(0xFF1E273B);
const secondaryBackgroundDark = Color(0xFF404E68);

const primaryTextLight = Color(0xFF1A1A1A);
const primaryTextDark = Color(0xFFF5F5F5);
const secondaryTextLight = Color(0xFF6B6B6B);
const secondaryTextDark = Color(0xFFB0B0B0);

@immutable
class AppColorSet extends ThemeExtension<AppColorSet> {
  final String name;
  final Color primaryOne;
  final Color primaryTwo;
  final Color? primaryThree;
  final Color alternateOne;
  final Color alternateTwo;
  final Color? alternateThree;
  final Color retroOne;
  final Color retroTwo;
  final Color? retroThree;
  final Color darkButtonBorders;
  final Color lightButtonBorders;
  final Color transparentButtonBorders;
  final Color darkButtonBackground;
  final Color lightButtonBackground;
  final Color transparentButtonBackground;
  final Color darkButtonTextColor;
  final Color lightButtonTextColor;
  final Color transparentButtonTextColor;
  final Color actionButtonBorders;
  final Color textFieldBorders;
  final Color dropDownBorders;
  final Color labelSelectedBackground;
  final Color labelSelectedBorders;
  final Color labelUnselectedBackground;
  final Color labelUnselectedBorders;
  final Color containersBorders;
  final Color altContBorders;

  const AppColorSet({
    required this.name,
    required this.primaryOne,
    required this.primaryTwo,
    this.primaryThree,
    required this.alternateOne,
    required this.alternateTwo,
    this.alternateThree,
    required this.retroOne,
    required this.retroTwo,
    this.retroThree,
    required this.darkButtonBorders,
    required this.lightButtonBorders,
    required this.transparentButtonBorders,
    required this.darkButtonBackground,
    required this.lightButtonBackground,
    required this.transparentButtonBackground,
    required this.darkButtonTextColor,
    required this.lightButtonTextColor,
    required this.transparentButtonTextColor,
    required this.actionButtonBorders,
    required this.textFieldBorders,
    required this.dropDownBorders,
    required this.labelSelectedBackground,
    required this.labelSelectedBorders,
    required this.labelUnselectedBackground,
    required this.labelUnselectedBorders,
    required this.containersBorders,
    required this.altContBorders,
  });

  LinearGradient gradientBackground({
    List<double>? stops,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return gradient(
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  LinearGradient gradientCircle({
    List<double>? stops,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return gradient(
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  LinearGradient gradientText({
    List<double>? stops,
    Alignment begin = Alignment.centerLeft,
    Alignment end = Alignment.centerRight,
  }) {
    return gradient(
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  LinearGradient gradientLinear({
    List<double>? stops,
    Alignment begin = const Alignment(1, -1),
    Alignment end = const Alignment(-1, 1),
  }) {
    return gradient(
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  LinearGradient gradient({
    List<double>? stops, // distributed evenly if null
    required Alignment begin,
    required Alignment end,
  }) {
    final colorsList = primaryThree == null ? [primaryOne, primaryTwo] : [primaryOne, primaryThree!, primaryTwo];

    return LinearGradient(
      colors: colorsList,
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  @override
  AppColorSet copyWith({
    String? name,
    Color? pOne,
    Color? pTwo,
    Color? pThree,
    Color? aOne,
    Color? aTwo,
    Color? aThree,
    Color? rOne,
    Color? rTwo,
    Color? rThree,
    Color? darkBtnBorders,
    Color? lightBtnBorders,
    Color? transpBtnBorders,
    Color? darkBtnBkg,
    Color? lightBtnBkg,
    Color? transpBtnBkg,
    Color? darkBtnText,
    Color? lightBtnText,
    Color? transpBtnText,
    Color? actionBtnBorders,
    Color? actionBtnBackground,
    Color? actionBtnIcon,
    Color? textBorders,
    Color? textBackground,
    Color? textColor,
    Color? textLabel,
    Color? ddBorders,
    Color? ddBkg,
    Color? ddIcon,
    Color? ddText,
    Color? labelSelBkg,
    Color? labelSelIcon,
    Color? labelSelBorders,
    Color? labelUnselBkg,
    Color? labelUnselIcon,
    Color? labelUnselBorders,
    Color? contBorders,
    Color? contAltBorders,
  }) {
    return AppColorSet(
      name: name ?? "NotValid",
      primaryOne: pOne ?? primaryOne,
      primaryTwo: pTwo ?? primaryTwo,
      primaryThree: pThree ?? primaryThree,
      alternateOne: aOne ?? alternateOne,
      alternateTwo: aTwo ?? alternateTwo,
      alternateThree: aThree ?? alternateThree,
      retroOne: rOne ?? retroOne,
      retroTwo: rTwo ?? retroTwo,
      retroThree: rThree ?? retroThree,
      darkButtonBorders: darkBtnBorders ?? darkButtonBorders,
      lightButtonBorders: lightBtnBorders ?? lightButtonBorders,
      transparentButtonBorders: transpBtnBorders ?? transparentButtonBorders,
      darkButtonBackground: darkBtnBkg ?? darkButtonBackground,
      lightButtonBackground: lightBtnBkg ?? lightButtonBackground,
      transparentButtonBackground: transpBtnBkg ?? transparentButtonBackground,
      darkButtonTextColor: darkBtnText ?? darkButtonTextColor,
      lightButtonTextColor: lightBtnText ?? lightButtonTextColor,
      transparentButtonTextColor: transpBtnText ?? transparentButtonTextColor,
      actionButtonBorders: actionBtnBorders ?? actionButtonBorders,
      textFieldBorders: textBorders ?? textFieldBorders,
      dropDownBorders: ddBorders ?? dropDownBorders,
      labelSelectedBackground: labelSelBkg ?? labelSelectedBackground,
      labelSelectedBorders: labelSelBorders ?? labelSelectedBorders,
      labelUnselectedBackground: labelUnselBkg ?? labelUnselectedBackground,
      labelUnselectedBorders: labelUnselBorders ?? labelUnselectedBorders,
      containersBorders: contBorders ?? containersBorders,
      altContBorders: contAltBorders ?? altContBorders,
    );
  }

  // Linear interpolation, to animate between themes (parameter t: [0;1])
  @override
  AppColorSet lerp(ThemeExtension<AppColorSet>? other, double t) {
    if (other is! AppColorSet) return this;
    return AppColorSet(
      name: other.name,
      primaryOne: Color.lerp(primaryOne, other.primaryOne, t)!,
      primaryTwo: Color.lerp(primaryTwo, other.primaryTwo, t)!,
      primaryThree: Color.lerp(primaryThree, other.primaryThree, t),
      alternateOne: Color.lerp(alternateOne, other.alternateOne, t)!,
      alternateTwo: Color.lerp(alternateTwo, other.alternateTwo, t)!,
      alternateThree: Color.lerp(alternateThree, other.alternateThree, t),
      retroOne: Color.lerp(retroOne, other.retroOne, t)!,
      retroTwo: Color.lerp(retroTwo, other.retroTwo, t)!,
      retroThree: Color.lerp(retroThree, other.retroThree, t),
      darkButtonBorders: Color.lerp(darkButtonBorders, other.darkButtonBorders, t)!,
      darkButtonBackground: Color.lerp(darkButtonBackground, other.darkButtonBackground, t)!,
      darkButtonTextColor: Color.lerp(darkButtonTextColor, other.darkButtonTextColor, t)!,
      lightButtonBorders: Color.lerp(lightButtonBorders, other.lightButtonBorders, t)!,
      lightButtonBackground: Color.lerp(lightButtonBackground, other.lightButtonBackground, t)!,
      lightButtonTextColor: Color.lerp(lightButtonTextColor, other.lightButtonTextColor, t)!,
      transparentButtonBorders: Color.lerp(transparentButtonBorders, other.transparentButtonBorders, t)!,
      transparentButtonBackground: Color.lerp(transparentButtonBackground, other.transparentButtonBackground, t)!,
      transparentButtonTextColor: Color.lerp(transparentButtonTextColor, other.transparentButtonTextColor, t)!,
      actionButtonBorders: Color.lerp(actionButtonBorders, other.actionButtonBorders, t)!,
      textFieldBorders: Color.lerp(textFieldBorders, other.textFieldBorders, t)!,
      dropDownBorders: Color.lerp(dropDownBorders, other.dropDownBorders, t)!,
      labelSelectedBackground: Color.lerp(labelSelectedBackground, other.labelSelectedBackground, t)!,
      labelSelectedBorders: Color.lerp(labelSelectedBorders, other.labelSelectedBorders, t)!,
      labelUnselectedBackground: Color.lerp(labelUnselectedBackground, other.labelUnselectedBackground, t)!,
      labelUnselectedBorders: Color.lerp(labelUnselectedBorders, other.labelUnselectedBorders, t)!,
      containersBorders: Color.lerp(containersBorders, other.containersBorders, t)!,
      altContBorders: Color.lerp(altContBorders, other.altContBorders, t)!,
    );
  }
}

const theBay = AppColorSet(
    name: "theBay",
    primaryOne: royalBlue,
    primaryTwo: goldenYellow,
    primaryThree: white,
    alternateOne: blackWash,
    alternateTwo: darkerGold,
    alternateThree: white,
    retroOne: night,
    retroTwo: darkerGold,
    retroThree: persianRed,
    darkButtonBorders: persianRed,
    lightButtonBorders: pictonBlue,
    transparentButtonBorders: persianRed,
    darkButtonBackground: marianBlue,
    lightButtonBackground: airForceBlue,
    transparentButtonBackground: transparentGold,
    darkButtonTextColor: darkerGold,
    lightButtonTextColor: white,
    transparentButtonTextColor: oxfordBlue,
    actionButtonBorders: persianRed,
    textFieldBorders: marianBlue,
    dropDownBorders: marianBlue,
    labelSelectedBackground: pictonBlue,
    labelSelectedBorders: persianRed,
    labelUnselectedBackground: oxfordBlue,
    labelUnselectedBorders: airForceBlue,
    containersBorders: persianRed,
    altContBorders: pictonBlue // or airForceBlue
    );

const List<AppColorSet> themeList = [theBay];
