import 'package:flutter/material.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';

class AnalyticsWidget extends StatefulWidget {
  final List<CounterRecordModel> counterRecordList;
  const AnalyticsWidget({super.key, required this.counterRecordList});

  @override
  State<AnalyticsWidget> createState() => _AnalyticsWidgetState();
}

class _AnalyticsWidgetState extends State<AnalyticsWidget> {
  getTitleWidget(String title, int value,
      {bool isHighlight = false, Widget? marketWidget}) {
    return Expanded(
        child: RoundedContainer(
            marketWidget: marketWidget,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "$title : ",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                CircleAvatar(
                    radius: 22,
                    child: Text("${HelperFunction.minimizeLargeNumber(value)}"))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    var counterRecords = widget.counterRecordList;

    int currentStreak = HelperFunction.getContinousStreak(counterRecords);
    int maxStreak = HelperFunction.maxStreakFunction(counterRecords);
    // [average,maxv]
    var avgMax = HelperFunction.getAverageOfRecords(counterRecords);
    var isMaxstreakReached = currentStreak >= maxStreak && currentStreak != 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              getTitleWidget("Current streak", currentStreak,
                  isHighlight: isMaxstreakReached,
                  marketWidget: isMaxstreakReached ? Text('❤️') : null),
              SizedBox(width: 8),
              getTitleWidget("Max streak", maxStreak,
                  marketWidget: isMaxstreakReached ? Text('🔥') : null),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              getTitleWidget('Average', avgMax[0]),
              SizedBox(width: 8),
              getTitleWidget("Max count", avgMax[1]),
            ],
          ),
        ],
      ),
    );
  }
}
