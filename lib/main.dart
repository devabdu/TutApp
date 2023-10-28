import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/presentation/resources/language_manager.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  //SharedPreferences preferences = await SharedPreferences.getInstance();
  //await preferences.clear();
  runApp(
    EasyLocalization(
      supportedLocales: const [englishLocal, arabicLocal],
      path: assetPathLocalization,
      child: Phoenix(
        child: MyApp(),
      ),
    ),
  );
}
