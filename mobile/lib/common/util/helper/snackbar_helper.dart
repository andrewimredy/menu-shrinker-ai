import 'package:flutter/material.dart';

import '../../common.dart';

class SnackbarHelper {
  const SnackbarHelper._();

  static void showSuccess({required BuildContext context, required String message}) {
    show(context: context, message: message, backgroundColor: greenColor, foregroundColor: whiteColor);
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      duration: duration,
      backgroundColor: redColor,
      foregroundColor: whiteColor,
    );
  }

  static void showInfo({required BuildContext context, required String message}) {
    show(
      context: context,
      message: message,
      backgroundColor: messageGreyColor, // TODO temporary colors
      foregroundColor: primaryColor,
    );
  }

  static void show({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.only(left: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0.0,
        duration: duration,
        content: Row(
          children: [
            Expanded(child: Text(message, style: listItemStyle)),
            IconButton(onPressed: messenger.clearSnackBars, icon: Icon(Icons.close, color: foregroundColor)),
          ],
        ),
      ),
    );
  }
}
