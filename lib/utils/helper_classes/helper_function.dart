import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/constants/big_list.dart';
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

  static int actualDayDifference(DateTime date1, DateTime date2) {
    var newDate1 = DateTime(date1.year, date1.month, date1.day);
    var newDate2 = DateTime(date2.year, date2.month, date2.day);
    var diff = newDate1.difference(newDate2).inDays.abs();
    return diff;
  }

  static int getContinousStreak(List<CounterRecordModel> records) {
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    int count = 0;
    for (var i = 0; i < records.length; i++) {
      if (i == 0) {
        count = 1;
      } else {
        if (actualDayDifference(records[i].dateTime, records[i - 1].dateTime) <=
            1) {
          count += 1;
        } else {
          break;
        }
      }
    }
    return count;
  }

  static String getRandomMotivationalImage() {
    var random = Random();
    int randomNumber = random.nextInt(BigList.motivationalImageList.length - 1);
    return BigList.motivationalImageList[randomNumber];
  }

  static fillStreakValue(List<CounterRecordModel> records) {
    // sort in ascending order to increate streak count from previous days to currnet days.
    records.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    int count = 0;
    CounterRecordModel? previousRecord;
    for (var i = 0; i < records.length; i++) {
      if (previousRecord == null) {
        previousRecord = records[i];
      } else {
        if (actualDayDifference(previousRecord.dateTime, records[i].dateTime) >
            1) {
          count = 1;
          previousRecord = records[i];
          records[i].streakv = count;
          continue;
        }
        records[i].streakv = count + 1;
        previousRecord = records[i];
      }
      count += 1;
    }
    //reverse the list back to descending order.
    records = records.reversed.toList();
    return records;
  }

  static maxStreakFunction(List<CounterRecordModel> records) {
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    int maxStreak = 0;
    int currMax = 0;
    for (var i = 0; i < records.length; i++) {
      if (i == 0) {
        currMax = 1;
      } else {
        if (actualDayDifference(records[i].dateTime, records[i - 1].dateTime) <=
            1) {
          currMax += 1;
        } else {
          maxStreak = currMax > maxStreak ? currMax : maxStreak;
          currMax = 1;
        }
      }
    }

    maxStreak = currMax > maxStreak ? currMax : maxStreak;
    return maxStreak;
  }

  static String minimizeLargeNumber(int number) {
    if (number < 10000) {
      return number.toString();
    }
    return (number / 1000).toStringAsFixed(1).toString() + "k";
  }

// it returns the average and maxv
  static List<int> getAverageOfRecords(List<CounterRecordModel> records) {
    if (records.isEmpty) return [0, 0];
    List<double> data = records.map((e) => e.countValue.toDouble()).toList();

    // Step 1: Calculate median
    double median = _calculateMedian(data);

    // Step 2: Calculate median absolute deviation (MAD)
    double mad = _calculateMAD(data, median);

    // Step 3: Define threshold value for outliers
    double threshold = 3 * mad;

    // Step 4: Filter out outliers
    List<double> filteredData =
        data.where((x) => (x - median).abs() < threshold).toList();

    if (filteredData.isEmpty) filteredData = data;

    double sumv = 0;
    double maxv = 0;
    for (var item in filteredData) {
      sumv += item;
      maxv = maxv > item ? maxv : item;
    }

    return [(sumv / (filteredData.length)).round(), maxv.toInt()];
  }
}

double _calculateMedian(List<double> data) {
  data.sort();
  int n = data.length;
  if (n % 2 == 0) {
    return (data[n ~/ 2 - 1] + data[n ~/ 2]) / 2;
  } else {
    return data[n ~/ 2];
  }
}

double _calculateMAD(List<double> data, double median) {
  List<double> deviations = data.map((x) => (x - median).abs()).toList();
  return _calculateMedian(deviations);
}
