Future<List<String>> convertDecimalListToHexList(List<int> decimalList) async {
  return decimalList.map((int value) => value.toRadixString(16)).toList();
}

Future<String> convertHexListToString(List<String> hexList) async {
  return hexList.map((hex) {
    int decimalValue = int.parse(hex, radix: 16);
    if (decimalValue >= 32 && decimalValue <= 126) {
      return String.fromCharCode(decimalValue);
    } else {
      return ''; // or any other replacement for non-printable characters
    }
  }).join('');
}

Future<String> getTextFromHex(List<List<String>> blocksdata) async {
  List<String> textList = [];
  for (var x in blocksdata) {
    String txt = await convertHexListToString(x);
    if (txt.isNotEmpty) {
      textList.add(txt);
    } else {}
  }
  String concatenatedText = textList.join('');
  return concatenatedText;
}
