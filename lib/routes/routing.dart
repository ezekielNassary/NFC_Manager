import 'package:get/get.dart';
import 'package:nfc_manager_app/home.dart';
import 'package:nfc_manager_app/screens/dashboard/controller.dart';
import 'package:nfc_manager_app/screens/splashscreen/splashscreen.dart';

import 'pagenames.dart';

class PageRouter {
  static List<GetPage> pages = [
    GetPage(
        name: PageName.splash,
        page: () => SplashScreen(),
        bindings: [NfcKitBinding()]),
    GetPage(
        name: PageName.dashboard,
        page: () => HomePage(),
        bindings: [NfcKitBinding()]),
  ];
}
