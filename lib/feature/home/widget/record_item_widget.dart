import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';

class RecordItemWidget extends StatelessWidget {
  final CounterRecordModel counterRecordItem;
  final Function onDeleteClick;
  const RecordItemWidget(
      {super.key,
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
    var formattedDateTitle =
        HelperFunction.getDateString(counterRecordItem.dateTime);
    return InkWell(
      onTap: () {
        if (HelperFunction.isTodayDate(counterRecordItem.dateTime)) {
          Navigator.of(context).pushNamed(RouteName.counterRecordScreen,
              arguments: CounterRecordArgs(
                  counterId: counterRecordItem.counterId,
                  counterRecordModel: counterRecordItem));
        } else {
          Fluttertoast.showToast(
              msg: 'Previous days records can\'t be updated ! ');
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
        color: Theme.of(context).highlightColor,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(top: 8),
        // height: 78,
        child: Row(
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                '${formattedDateTitle}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            CircleAvatar(
              radius: 24,
              child: Text("${counterRecordItem.countValue}"),
            )
          ],
        ),
      ),
    );
  }
}
