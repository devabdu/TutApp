import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: FontConst.fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

/// bold style
TextStyle getBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(fontSize, FontWightManager.bold, color);
}

/// semiBold style
TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(fontSize, FontWightManager.semiBold, color);
}

/// medium style
TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(fontSize, FontWightManager.medium, color);
}

/// regular style
TextStyle getRegularStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(fontSize, FontWightManager.regular, color);
}

/// light style
TextStyle getLightStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(fontSize, FontWightManager.light, color);
}