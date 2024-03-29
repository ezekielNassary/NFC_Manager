import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nfc_manager_app/header.dart';
import 'package:nfc_manager_app/screens/cards/advanced.dart';
import 'package:nfc_manager_app/screens/cards/setting.dart';
import 'package:nfc_manager_app/screens/cards/write_card.dart';
import 'package:nfc_manager_app/screens/dashboard/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const Dashboard(),
    HeaderWidget(
      screen: const WriteCard(),
    ),
    HeaderWidget(screen: const AdvancedOptions()),
    HeaderWidget(screen: Settings())
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                const GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                const GButton(
                  icon: Icons.credit_card,
                  text: 'Cards',
                ),
                const GButton(
                  icon: Icons.vibration,
                  text: 'Advanced',
                ),
                const GButton(
                  icon: Icons.settings,
                  text: 'Setting',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
