import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/presentation/main/pages/home/view/home_page.dart';
import 'package:tut_app/presentation/main/pages/notification/notification_page.dart';
import 'package:tut_app/presentation/main/pages/search/search_page.dart';
import 'package:tut_app/presentation/main/pages/seetings/settings.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/strings_manager.dart';
import 'package:tut_app/presentation/resources/values_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = [
    HomePage(),
    SearchPage(),
    NotificationPage(),
    SettingsPage()
  ];
  List<String> titles = [
    AppStrings.homePage.tr(),
    AppStrings.searchPage.tr(),
    AppStrings.notificationPage.tr(),
    AppStrings.settingsPage.tr()
  ];
  var _title = AppStrings.homePage.tr();
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
          style: Theme
              .of(context)
              .textTheme
              .titleSmall,
        ),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration:  BoxDecoration(
          boxShadow:[
            BoxShadow(color: ColorManager.lightGrey, spreadRadius: AppSize.s1)
          ],
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: AppStrings.homePage.tr()),
            BottomNavigationBarItem(icon: const Icon(Icons.search_outlined), label: AppStrings.searchPage.tr()),
            BottomNavigationBarItem(icon: const Icon(Icons.notifications_outlined), label: AppStrings.notificationPage.tr()),
            BottomNavigationBarItem(icon: const Icon(Icons.settings_outlined), label: AppStrings.settingsPage.tr()),
          ],
        ),
      ),
    );
  }
  onTap(int index){
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}
