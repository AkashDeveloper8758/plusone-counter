import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/feature/home/widget/analytics_widget.dart';
import 'package:plusone_counter/feature/home/widget/record_chart_widget.dart';
import 'package:plusone_counter/feature/home/widget/record_item_widget.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';

import '../../../controllers/home_controllers.dart';
import '../../../utils/initials/app_routes.dart';

class CounterRecordDetailScreen extends StatefulWidget {
  final CounterModel counterModel;
  const CounterRecordDetailScreen({super.key, required this.counterModel});

  @override
  State<CounterRecordDetailScreen> createState() =>
      _CounterRecordDetailScreenState();
}

class _CounterRecordDetailScreenState extends State<CounterRecordDetailScreen> {
  final HomeController _homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    String goalStreakString = '';
    if (widget.counterModel.dailyGoal != null) {
      goalStreakString += '🎯 ${widget.counterModel.dailyGoal}';
    }
    if (widget.counterModel.counterRecords.isNotEmpty) {
      goalStreakString +=
          ' 🔥 ${HelperFunction.getContinousStreak(widget.counterModel.counterRecords)}';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.counterModel.counterTitle,
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(overflow: TextOverflow.ellipsis),
        ),
        actions: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$goalStreakString',
                style: Theme.of(context).textTheme.titleMedium,
              ))
        ],
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Column(
                    children: [
                      RecordChart(
                          counterRecordList: _homeController
                              .getRecordByCounter(widget.counterModel.id)),
                      AnalyticsWidget(
                          counterRecordList:
                              widget.counterModel.counterRecords),
                    ],
                  ),
                )),
            Obx(() {
              var recordsList =
                  _homeController.getRecordByCounter(widget.counterModel.id);
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recordsList.length,
                itemBuilder: (context, index) {
                  var recordItem = recordsList[index];
                  Widget? previousWidget;
                  if (index > 0) {
                    int prevDiff = HelperFunction.actualDayDifference(
                        recordItem.dateTime, recordsList[index - 1].dateTime);
                    if (prevDiff > 1) {
                      previousWidget = Container(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          '${prevDiff - 1} days missed ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                  }

                  return Column(
                    children: [
                      if (previousWidget != null)
                        previousWidget
                      else if (index != 0)
                        Container(
                          height: 12,
                          width: 12,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      RecordItemWidget(
                        counterModel: widget.counterModel,
                        counterRecordItem: recordItem,
                        onDeleteClick: () {
                          _homeController.removeRecord(recordItem);
                        },
                      ),
                    ],
                  );
                },
              );
            }),
            SizedBox(height: 100),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        onPressed: () {
          if (widget.counterModel.counterRecords
              .any((element) => HelperFunction.isTodayDate(element.dateTime))) {
            Fluttertoast.showToast(msg: 'Todays record is already added');
            return;
          }
          Navigator.of(context).pushNamed(RouteName.counterRecordScreen,
              arguments: CounterRecordArgs(counterModel: widget.counterModel));
        },
        label: Text('Add record'),
      ),
    );
  }
}
