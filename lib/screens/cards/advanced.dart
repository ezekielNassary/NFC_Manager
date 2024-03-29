import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:nfc_manager_app/screens/dashboard/controller.dart';
import 'package:nfc_manager_app/utils/dialogs.dart';

class AdvancedOptions extends StatefulWidget {
  const AdvancedOptions({super.key});

  @override
  State<AdvancedOptions> createState() => _AdvancedOptionsState();
}

class _AdvancedOptionsState extends State<AdvancedOptions> {
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
  final formKey = GlobalKey<FormState>();
  String selectedValue = 'Phone';
  String makeDivisibleByFour(String text) {
    int length = text.length;
    int remainder = length % 4;
    if (remainder == 0) {
      return text;
    } else {
      int missingChars = 4 - remainder;
      return text + '#' * missingChars;
    }
  }

  @override
  void initState() {
    checkDeviceSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Advanced Options",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          tile_setting(
            title: 'Create Details List',
            subtitle: "Create list of informations",
            icon: Icons.subject,
            widget: Icon(Icons.lock),
          ),
          tile_setting(
            title: 'Clear Details',
            subtitle: "Delete all records",
            icon: Icons.delete_forever,
            widget: Text(""),
          ),
          tile_setting(
            title: 'Write In Specific Blocks',
            subtitle: "Choose a specific block to write",
            icon: Icons.wifi_protected_setup,
            widget: Icon(Icons.lock),
          ),
          tile_setting(
            title: 'Lock Card',
            subtitle: "Lock card information",
            icon: Icons.not_interested,
            widget: Icon(Icons.lock),
          ),
          tile_setting(
            title: 'Set Sart Stop Bits',
            subtitle: "Set how will extract your data",
            icon: Icons.spellcheck,
            widget: Icon(Icons.lock),
          ),
          SizedBox(
            height: 25,
          ),
          Text("The basic version support only Mifare Utralight Cards"),
        ],
      ),
    );
  }
}

class tile_setting extends StatelessWidget {
  tile_setting({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.widget,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          size: 35,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget), // Wrap the widget with Flexible
      ),
    );
  }
}
