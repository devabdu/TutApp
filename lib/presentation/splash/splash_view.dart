import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/presentation/resources/assets_manager.dart';
import 'package:tut_app/presentation/resources/color_manager.dart';
import 'package:tut_app/presentation/resources/constants_manager.dart';
import 'package:tut_app/presentation/resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() {
    _appPreferences.isUserLoggedIn().then((isLogged) => {
          if (isLogged)
            {Navigator.pushReplacementNamed(context, Routes.mainRoute)}
          else
            {
              _appPreferences.isOnBoardingScreenViewed().then((isViewed) =>
                  isViewed
                      ? Navigator.pushReplacementNamed(context, Routes.loginRoute)
                      : Navigator.pushReplacementNamed(context, Routes.onBoardingRoute))
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
        child: Image(
          image: AssetImage(ImagesAssets.splashLogo),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
