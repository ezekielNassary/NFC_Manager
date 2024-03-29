import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:nfc_manager_app/screens/dashboard/controller.dart';
import 'package:nfc_manager_app/utils/dialogs.dart';

class WriteCard extends StatefulWidget {
  const WriteCard({super.key});

  @override
  State<WriteCard> createState() => _WriteCardState();
}

class _WriteCardState extends State<WriteCard> {
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
          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //       color: Colors.blue, borderRadius: BorderRadius.circular(15)),
          //   child: Column(
          //     children: [
          //       Text(
          //         "Pro version is available with more advanced features",
          //         style: TextStyle(color: Colors.amber),
          //       ),
          //       SizedBox(
          //         height: 5,
          //       ),
          //       OutlinedButton(onPressed: () {}, child: Text("Subscribe Now"))
          //     ],
          //   ),
          // ),
          Text(
            "Card Manager",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Read Card Records",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                  height: 30,
                ),
                IconButton(
                    onPressed: () async {
                      loadingDialog(context, "Scan your card");
                      await controller.transceiveReadMultiplePage(4, 20);
                      if (!controller.loading.value) {
                        Get.back();
                        if (!controller.carderror.value) {
                          Get.bottomSheet(
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text(
                                    "Card Records",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("Records"),
                                  Divider(),
                                  Obx(() => Text(controller.mytext.value))
                                ],
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                          );
                        } else {
                          errorDialog(context, "Card Error",
                              controller.errorText.value);
                        }
                      }
                    },
                    icon: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.2)),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.5)),
                        child: Icon(
                          Icons.center_focus_weak,
                          size: 100,
                          color: Colors.blue,
                        ),
                      ),
                    ))
              ],
            ),
          ),
          Form(
            key: formKey,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 2,
              shadowColor: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "What do you want to write in your nfc card today?",
                        style: TextStyle(fontSize: 21),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity, // Set width to 100%
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey)),
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: selectedValue,
                        isExpanded: true,
                        elevation: 4,
                        borderRadius: BorderRadius.circular(15),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        alignment: Alignment.center,
                        items: <String>[
                          'Phone',
                          'Email',
                          'Website',
                          'Balance',
                          "Other"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(fontSize: 20),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        controller: inputcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please write something";
                          }
                        },
                        keyboardType: selectedValue == "Phone"
                            ? TextInputType.phone
                            : selectedValue == "Email"
                                ? TextInputType.emailAddress
                                : selectedValue == "Website"
                                    ? TextInputType.url
                                    : selectedValue == "Balance"
                                        ? TextInputType.number
                                        : selectedValue == "Other"
                                            ? TextInputType.text
                                            : TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      child: OutlinedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              loadingDialog(context, "Scan Card");

                              String data =
                                  '*[(${inputcontroller.text.toString()})]*';
                              String text = makeDivisibleByFour(data);
                              print(text);
                              await controller.writeDataToCard(4, text);
                              if (!controller.loading.value) {
                                Get.back();
                                if (!controller.carderror.value) {
                                  successDialog(context, "Success",
                                      "Data saved successfully");
                                }
                                inputcontroller.text = "";
                              }
                            }
                          },
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Container(
                          width: double.infinity,
                          child: Text(
                            '${controller.errorText}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
