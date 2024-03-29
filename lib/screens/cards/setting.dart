import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:nfc_manager_app/screens/dashboard/controller.dart';
import 'package:nfc_manager_app/utils/dialogs.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool support = false;
  final controller = Get.find<NfcKitController>();
  checkDeviceSupport() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      setState(() {
        support = true;
      });
    }
  }

  TextEditingController inputcontroller = TextEditingController();

  @override
  void initState() {
    checkDeviceSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.png'), fit: BoxFit.cover)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "NFC Manger V 1.0",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: double.infinity,
              child: Text("Contact Programmer: easydigital255@gmail.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
