import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/font_manager.dart';
import 'package:tut_app/presentation/resources/style_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    /// main colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    splashColor: ColorManager.lightPrimary,

    /// cardView theme
    cardTheme: const CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),

    /// appBar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.lightPrimary,
      elevation: AppSize.s4,
      shadowColor: ColorManager.lightPrimary,
      titleTextStyle: getRegularStyle(
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
    ),

    /// button theme
    buttonTheme: const ButtonThemeData(
      shape: StadiumBorder(),
      disabledColor: ColorManager.grey1,
      buttonColor: ColorManager.primary,
      splashColor: ColorManager.lightPrimary,
    ),

    /// elevatedButton theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(
          color: ColorManager.white,
          fontSize: FontSize.s17,
        ),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s12),
        ),
      ),
    ),

    /// text theme
    textTheme: TextTheme(
      displayLarge: getSemiBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.darkGrey,
      ),
      headlineLarge: getSemiBoldStyle(
        fontSize: FontSize.s16,
        color: ColorManager.darkGrey,
      ),
      headlineMedium: getRegularStyle(
        fontSize: FontSize.s14,
        color: ColorManager.darkGrey,
      ),
      titleMedium: getMediumStyle(
        fontSize: FontSize.s16,
        color: ColorManager.primary,
      ),
      titleSmall: getRegularStyle(
        fontSize: FontSize.s16,
        color: ColorManager.white,
      ),
      labelSmall: getBoldStyle(
        fontSize: FontSize.s12,
        color: ColorManager.primary,
      ),
      bodyMedium: getRegularStyle(
        fontSize: FontSize.s12,
        color: ColorManager.grey2,
      ),
      bodyLarge: getRegularStyle(color: ColorManager.grey1),
      bodySmall: getRegularStyle(color: ColorManager.grey),
    ),

    /// input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      hintStyle: getRegularStyle(
        fontSize: AppSize.s14,
        color: ColorManager.grey,
      ),
      labelStyle: getMediumStyle(
        fontSize: AppSize.s14,
        color: ColorManager.grey,
      ),
      errorStyle: getRegularStyle(color: ColorManager.error),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.error, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide:
            BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(
          Radius.circular(AppSize.s8),
        ),
      ),
    ),
  );
}
