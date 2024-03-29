import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager_app/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      duration: const Duration(milliseconds: 2000),
      nextScreen: const HomePage(),
      backgroundColor: Colors.white,
      splashScreenBody: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: Image.asset('assets/splash.png'),
            ),
            const Spacer(),
            const Text(
              "DEVELOPMENT MADE EASY",
              style: TextStyle(color: Colors.pink, fontSize: 20),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
