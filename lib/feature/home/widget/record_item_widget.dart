import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';

class RecordItemWidget extends StatelessWidget {
  final CounterRecordModel counterRecordItem;
  final Function onDeleteClick;
  final CounterModel counterModel;
  const RecordItemWidget(
      {super.key,
      required this.counterModel,
      required this.counterRecordItem,
      required this.onDeleteClick});

  _showPopupMenu(Offset offset, BuildContext context) async {
    return await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(Get.width, offset.dy, 0, 0),
      items: [
        PopupMenuItem(
          child: Text('Delete'),
          value: 1,
        ),
      ],
      elevation: 8.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    int? dailyGoal = counterModel.dailyGoal;
    var formattedDateTitle =
        HelperFunction.getDateString(counterRecordItem.dateTime);
    int? percentageComplete;

    List<TextSpan> richChildrens = [];
    richChildrens.add(TextSpan(
        text: "${counterRecordItem.countValue}",
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold)));

    if (dailyGoal != null) {
      richChildrens.add(
          TextSpan(text: " | ", style: Theme.of(context).textTheme.bodyMedium));
      // richChildrens.add(TextSpan(
      //     text: " / $dailyGoal | ",
      //     style: Theme.of(context).textTheme.bodyMedium));
      percentageComplete =
          ((counterRecordItem.countValue / dailyGoal) * 100).round();
    }
    if (percentageComplete != null) {
      richChildrens.add(TextSpan(
          text: '$percentageComplete %',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: percentageComplete >= 100
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              )));
    }
    RichText richText =
        RichText(text: TextSpan(text: '', children: richChildrens));

    return InkWell(
      onTap: () {
        if (HelperFunction.isTodayDate(counterRecordItem.dateTime)) {
          Navigator.of(context).pushNamed(RouteName.counterRecordScreen,
              arguments: CounterRecordArgs(
                  counterModel: counterModel,
                  counterRecordModel: counterRecordItem));
        } else {
          Fluttertoast.showToast(
              msg: 'Previous days records can\'t be updated !  ');
        }
      },
      onLongPress: () async {
        final renderBox = context.findRenderObject() as RenderBox;
        final offset = renderBox.localToGlobal(Offset.zero);
        var resposne = await _showPopupMenu(offset, context);
        if (resposne == 1) {
          onDeleteClick();
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: EdgeInsets.all(16),
        // height: 78,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                formattedDateTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (counterRecordItem.streakv > 1)
              RoundedContainer(
                child: Container(
                  child: Text('${counterRecordItem.streakv} ⚡️'),
                ),
              ),
            SizedBox(width: 4),
            RoundedContainer(
              borderColor: percentageComplete != null
                  ? percentageComplete >= 100
                      ? Theme.of(context).primaryColor
                      : null
                  : null,
              child: Container(
                child: richText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
