import 'package:flutter/material.dart';

class NotificationService {
  static void showNotification(BuildContext context, {String? msg}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg ?? 'Something Went Wrong!'),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
