import 'package:flutter/material.dart';
import 'package:galleryapp/utils/app_colors.dart';
import 'package:intl/intl.dart';

commaSeperated(val) {
  var formatter = NumberFormat('#,##,000');
  if (val.toString().length < 3) {
    return val;
  }
  return formatter.format(val);
}

void createSnackBar(String message, context, color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(milliseconds: 800),
    ),
  );
}

showAlertDialog(BuildContext context,
    {required String message,
    required onYes,
    required String buttonAcceptTitle,
    required String buttonCancelTitle}) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    child: Text(
      buttonCancelTitle,
      style: const TextStyle(color: AppColors.primary),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text(
      buttonAcceptTitle,
      style: const TextStyle(color: AppColors.primary),
    ),
    onPressed: () {
      onYes();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
