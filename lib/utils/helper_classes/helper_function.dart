import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plusone_counter/utils/custom_components/conformation_dialog_box.dart';

class HelperFunction {
  static String getDateString(DateTime date) {
    return DateFormat('dd, MMM yyyy').format(date);
  }

  static Future<bool> showConfromationDialogBox(
      String title, BuildContext context) async {
    var res = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return ConformationDialogWidget(title: title);
        });
    return res ?? false;
  }

  static bool isTodayDate(DateTime otherTime) {
    var now = DateTime.now();
    return now.year == otherTime.year &&
        now.month == otherTime.month &&
        now.day == otherTime.day;
  }
}
