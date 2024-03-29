import 'package:dialogs/dialogs/message_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

successDialog(BuildContext context, String title, String message) {
  MessageDialog messageDialog = MessageDialog(
      dialogBackgroundColor: Colors.white,
      buttonOkColor: Colors.green,
      title: title,
      titleColor: Colors.black,
      message: message,
      messageColor: Colors.black,
      buttonOkText: 'Ok',
      dialogRadius: 15.0,
      buttonRadius: 18.0,
      iconButtonOk: Icon(Icons.one_k));
  messageDialog.show(context, barrierColor: Colors.white);
}

confirmDialog(BuildContext context, String title, String ctmmsg, String action,
    Function oncancel, Function onconfirm) {
  Dialogs.materialDialog(
      msg: ctmmsg,
      title: title,
      color: Theme.of(context).appBarTheme.backgroundColor!,
      context: context,
      actions: [
        IconsOutlineButton(
          onPressed: () {
            oncancel();
          },
          text: 'Cancel',
          iconData: Icons.cancel_outlined,
          textStyle: TextStyle(color: Colors.grey),
          iconColor: Colors.grey,
        ),
        IconsButton(
          onPressed: () {
            onconfirm();
          },
          text: action,
          iconData: Icons.delete,
          color: Colors.red,
          textStyle: TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
}

errorDialog(BuildContext context, String title, String message) {
  MessageDialog messageDialog = MessageDialog(
    dialogBackgroundColor: Colors.white,
    buttonOkColor: Colors.red,
    title: title,
    titleColor: Colors.black,
    message: message,
    messageColor: Colors.black,
    buttonOkText: 'Ok',
    dialogRadius: 15.0,
    buttonRadius: 18.0,
  );
  messageDialog.show(context, barrierColor: Colors.white);
}

loadingDialog(
  BuildContext context,
  String desc,
) {
  return Get.dialog(
      Dialog(
          backgroundColor: Theme.of(context).canvasColor,
          child: LoadingDialog(
            description: desc,
          )),
      barrierDismissible: false);
}

class LoadingDialog extends StatelessWidget {
  final String description;
  const LoadingDialog({
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: Theme.of(context).scaffoldBackgroundColor,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 5),
            child: Column(
              children: [
                SpinKitRipple(
                  color: Theme.of(context).colorScheme.outline,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(description)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
