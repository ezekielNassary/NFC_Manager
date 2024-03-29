import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager_app/home.dart';
import 'package:nfc_manager_app/routes/pagenames.dart';
import 'package:nfc_manager_app/routes/routing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NFC Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: PageName.splash,
        getPages: PageRouter.pages);
  }
}
