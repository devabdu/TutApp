import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/data/data_source/local_data_source.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/language_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          _getListTitle(
            context,
            leadingIcon: ImagesAssets.changeLanguageIcon,
            title: AppStrings.changeLanguage.tr(),
            trailingIcon: ImagesAssets.settingsRightArrowIcon,
            onTap: () {
              _changeLanguage();
            },
          ),
          _getListTitle(
            context,
            leadingIcon: ImagesAssets.contactUsIcon,
            title: AppStrings.contactUs.tr(),
            trailingIcon: ImagesAssets.settingsRightArrowIcon,
            onTap: () {
              _contactUs();
            },
          ),
          _getListTitle(
            context,
            leadingIcon: ImagesAssets.inviteYourFriendsIcon,
            title: AppStrings.inviteYourFriends.tr(),
            trailingIcon: ImagesAssets.settingsRightArrowIcon,
            onTap: () {
              _inviteFriends();
            },
          ),
          _getListTitle(
            context,
            leadingIcon: ImagesAssets.logoutIcon,
            title: AppStrings.logout.tr(),
            trailingIcon: ImagesAssets.settingsRightArrowIcon,
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  bool isRtl() {
    return context.locale == arabicLocal;
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  _contactUs() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamed(context, Routes.contactUsRoute);
    });
  }

  _inviteFriends() {
    Share.share(AppStrings.linkShare, subject: AppStrings.subjectShare);
  }

  _logout() {
    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

  Widget _getListTitle(
    BuildContext context, {
    required String leadingIcon,
    required String title,
    TextStyle? styleText,
    required String trailingIcon,
    required VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(isRtl() ? math.pi : 0),
        child: SvgPicture.asset(leadingIcon),
      ),
      title: Text(
        title,
        style: styleText ?? Theme.of(context).textTheme.bodyLarge,
      ),
      trailing: SvgPicture.asset(trailingIcon),
      onTap: onTap,
    );
  }
}
