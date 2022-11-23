import 'package:contactus/contactus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/font_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(title: Text(AppStrings.contactUs.tr(),)),
      body: Padding(
        padding: const EdgeInsets.only(top: AppPadding.p30),
        child: ContactUs(
          textColor: ColorManager.grey,
          textFont: FontConst.fontFamily,
          cardColor: ColorManager.white,

          companyName: AppStrings.companyName.tr(),
          companyFont: FontConst.fontFamily,
          companyFontSize: AppSize.s24,
          companyColor: ColorManager.primary,

          tagLine: AppStrings.tagLine.tr(),
          taglineFont: FontConst.fontFamily,
          taglineFontWeight: FontWightManager.regular,
          taglineColor: ColorManager.lightGrey,

          dividerThickness: .65,
          dividerColor: ColorManager.grey,

          emailText: AppStrings.emailHint.tr(),
          email: AppStrings.myEmail,
          emailColor: ColorManager.primary,

          githubUserName: AppStrings.githubUserName,
          githubColor: ColorManager.primary,

          linkedinURL: AppStrings.linkedinURL,
          linkedInColor: ColorManager.primary,
        ),
      ),
    );
  }
}
