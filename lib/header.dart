import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  HeaderWidget({super.key, required this.screen});
  final Widget screen;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsetsDirectional.only(top: 30),
        child: screen,
      ),
    ));
  }
}
