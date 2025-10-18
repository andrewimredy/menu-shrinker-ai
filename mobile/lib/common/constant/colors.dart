import 'package:flutter/cupertino.dart';

const primaryColor = Color(0xFF1CB0F6);
const primaryShadowColor = Color(0xFF1899D6);
const skyColor = Color(0xFFDDF4FF);
const lightBlueColor = Color(0xFF84D8FF);
const lightSkyColor = Color(0xFFE6F2FF);
const borderMessageColor = Color(0xFFB5CADD);
const whiteColor = Color(0xFFFFFFFF);
const blackColor = Color(0xFF000000);
const lightGreyColor = Color(0xFFE5E5E5);
const greyColor = Color(0xFF4B4B4B);
const messageGreyColor = Color(0xFF262628);
const subtitleGreyColor = Color(0xFF868C92);
const buttonGreyColor = Color(0xFFAFAFAF);
const orangeColor = Color(0xFFFFC800);
const greenColor = Color(0xFF26CB63);
const Color redColor = Color(0xFFEF5555);
const darkGreyColor = Color(0xFF3C3C3C);
const skyGradient = RadialGradient(radius: 1, colors: [Color(0xFF1CB0F6), Color(0xFF1478A3)], center: Alignment.center);
const linearWhiteGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.9],
  colors: [Color(0x00FFFFFF), whiteColor],
);
const blueTransparentGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.8029],
  colors: [Color(0x661CB0F6), Color(0x001CB0F6)],
);

const transparentToWhiteGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.7981, 1.0],
  colors: [Color(0x00FFFFFF), whiteColor],
);
