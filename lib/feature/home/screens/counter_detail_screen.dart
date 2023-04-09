import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.counterModel.counterTitle,
        style: Theme.of(context)
            .appBarTheme
            .titleTextStyle
            ?.copyWith(overflow: TextOverflow.ellipsis),
      )),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              var recordsList =
                  _homeController.getRecordByCounter(widget.counterModel.id);
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: recordsList.length,
                itemBuilder: (context, index) {
                  return RecordItemWidget(
                    counterRecordItem: recordsList[index],
                    onDeleteClick: () {
                      _homeController.removeRecord(recordsList[index]);
                    },
                  );
                },
              );
            })
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
              arguments: CounterRecordArgs(counterId: widget.counterModel.id));
        },
        label: Text('Add record'),
      ),
    );
  }
}
