import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:nfc_manager_app/screens/dashboard/controller.dart';
import 'package:nfc_manager_app/utils/dialogs.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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

  @override
  void initState() {
    checkDeviceSupport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          margin: EdgeInsetsDirectional.only(top: 30),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Scan Now",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Text(
                          "Device Supported",
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        support
                            ? Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )
                            : Icon(
                                Icons.clear,
                                color: Colors.red,
                              )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          loadingDialog(context, "Place your card");
                          await controller.scancard();
                          if (!controller.loading.value) {
                            Get.back();
                          }
                        },
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3),
                                      width: 16)),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.filter_center_focus,
                                size: 100,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text(
                            'Card Details',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Card Number"),
                              trailing: Text('${controller.tagid}'),
                            )),
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Type"),
                              trailing: Text('${controller.type}'),
                            )),
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Standard"),
                              trailing: Text('${controller.std}'),
                            )),
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Size"),
                              trailing: Text('${controller.size} B'),
                            )),
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Block Size"),
                              trailing: Text('${controller.blsize} '),
                            )),
                      ),
                      Card(
                        child: Obx(() => ListTile(
                              leading: Text("Block Size"),
                              trailing: Text('${controller.blcount} '),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
