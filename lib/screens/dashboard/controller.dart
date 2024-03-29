// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:get/get.dart';
import 'package:nfc_manager_app/utils/dataconvert.dart';

class NfcKitController extends GetxController {
  // ============================ Mifare Utralight ============================
  static const MIFARE_ULTRALIGHT_WRITE_PAGE_COMMAND = 0xA2;
  static const MIFARE_ULTRALIGHT_READ_PAGE_COMMAND = 0x3A;

// ================================= Mifare Classic ==========================
  static const int MIFARE_CLASSIC_AUTHENTICATION_KEY_A = 0x60;
  static const int MIFARE_CLASSIC_AUTHENTICATION_KEY_B = 0x61;
  static const int MIFARE_CLASSIC_READ_BLOCK = 0x30;
  static const int MIFARE_CLASSIC_WRITE_BLOCK = 0xA0;

  // ======================== Variables ========================
  var loading = false.obs;
  var carderror = false.obs;
  var errorText = "".obs;

  // ========================== Card Details =========================
  var tagid = "".obs;
  var type = "".obs;
  var size = "".obs;
  var std = "".obs;
  var blsize = "".obs;
  var blcount = "".obs;
  scancard() async {
    loading.value = true;
    tagid.value = "";
    type.value = "";
    var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
    loading.value = false;
    var data = jsonEncode(tag);
    Map<String, dynamic> decodedData = jsonDecode(data);
    tagid.value = decodedData['id'];
    type.value = decodedData['type'];
    std.value = decodedData['standard'];
    size.value = decodedData['mifareInfo']['size'].toString();
    blsize.value = decodedData['mifareInfo']['blockSize'].toString();
    blcount.value = decodedData['mifareInfo']['blockCount'].toString();
    print(decodedData);
    if (tag.ndefAvailable!) {
      for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
        // print(record.toString());
      }
      for (var record
          in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
        // print(jsonEncode(record).toString());
      }
    }
  }

  var mytext = "".obs;
  Future<void> transceiveReadMultiplePage(int start, int end) async {
    try {
      loading.value = true;
      errorText.value = "";
      var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 10));
      loading.value = false;
      if (tag.type == NFCTagType.mifare_ultralight) {
        carderror.value = false;
        Uint8List fastReadCommand = Uint8List.fromList([
          MIFARE_ULTRALIGHT_READ_PAGE_COMMAND,
          int.parse(start.toRadixString(16), radix: 16),
          int.parse(end.toRadixString(16), radix: 16),
        ]); //Read command for reading pages 4 to 7
        List<int> result = await FlutterNfcKit.transceive(fastReadCommand,
            timeout: const Duration(
                seconds:
                    5)); // timeout is still Android-only, persist until next change

        List<String> hexstr = await convertDecimalListToHexList(result);
        String text = await convertHexListToString(hexstr);
        String encrypted = extractValue(text);
        mytext.value = encrypted;
      } else if (tag.type == NFCTagType.mifare_classic) {
        loading.value = false;
        carderror.value = true;
        errorText.value = "Card Not Supported";
        // await FlutterNfcKit.authenticateSector(0,
        //     keyA: MIFARE_CLASSIC_AUTHENTICATION_KEY_A);
        // var data = await FlutterNfcKit.readSector(0); // read one sector, or
        // print(data);
        // var res = await FlutterNfcKit.readBlock(0); // read one block
        // print(res);
      } else {
        loading.value = false;
        carderror.value = true;
        errorText.value = "Card Not Supported";
      }
    } catch (e) {
      loading.value = false;
      carderror.value = true;
      errorText.value = "Card reading error";
    }
  }

  String extractValue(String inputText) {
    RegExp exp = RegExp(r'\*\[\(([^)]+?)\)\]\*');
    Match? match = exp.firstMatch(inputText);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return ""; // Return empty string if no match found
  }

  Future<void> writeDataToCard(int start, String data) async {
    errorText.value = "";
    loading.value = true;
    List<int> asciiValues = data.codeUnits;
    List<int> dt = [];
    for (var x in asciiValues) {
      int v = int.parse(x.toRadixString(16), radix: 16);
      dt.add(v);
    }
    try {
      var tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 10),
      );
      if (tag.type == NFCTagType.mifare_ultralight) {
        await cardwriter(dt, 4);
        loading.value = false;
        carderror.value = false;
      } else {
        loading.value = false;
        carderror.value = true;
        errorText.value = "Card Not Supported";
      }
    } catch (e) {
      loading.value = false;
      carderror.value = true;
      errorText.value = "Card writting error";
    }
  }

  Future<void> cardwriter(List<int> data, int startPage) async {
    const MAX_CHUNK_SIZE = 4; // Adjust based on your NFC tag's capabilities
    try {
      for (int i = 0; i < data.length; i += MAX_CHUNK_SIZE) {
        List<int> chunk = data.sublist(i, i + MAX_CHUNK_SIZE);
        Uint8List writePageCommand = Uint8List.fromList([
          MIFARE_ULTRALIGHT_WRITE_PAGE_COMMAND,
          startPage + i ~/ MAX_CHUNK_SIZE,
          ...chunk,
        ]);
        Uint8List response = await FlutterNfcKit.transceive(writePageCommand);
      }
    } catch (e) {
      print("Error writing data to NFC: $e");
    }
  }
}

class NfcKitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NfcKitController(), fenix: true);
  }
}
