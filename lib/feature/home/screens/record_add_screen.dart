import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/home_controllers.dart';
import '../../../utils/helper_classes/helper_function.dart';
import '../../../utils/helper_classes/response.dart';

class CounterScreen extends StatefulWidget {
  final String counterModelId;
  final CounterRecordModel? counterRecord;
  const CounterScreen(
      {super.key, required this.counterModelId, this.counterRecord});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final HomeController _homeController = Get.find();
  int counter = 0;
  bool _isUpdate = false;
  updateCounterBy(int value) {
    counter += value;
    if (counter < 0) counter = 0;
    setState(() {});
  }

  @override
  void initState() {
    _isUpdate = widget.counterRecord != null;
    if (_isUpdate) {
      counter = widget.counterRecord!.countValue;
    }
    super.initState();
  }

  String wind = 'https://media.tenor.com/U0SoTpb0Kb8AAAAC/baardy-turbine.gif';
  String fire = 'https://media.tenor.com/mSBwQxmbtoIAAAAC/fire.gif';

  @override
  Widget build(BuildContext context) {
    double mainHeight = Get.height - Get.statusBarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          HelperFunction.getDateString(DateTime.now()),
          style: Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(overflow: TextOverflow.ellipsis),
        ),
      ),
      body: Container(
          child: Stack(children: [
        Column(
          children: [
            Container(
              height: mainHeight * .3,
              child: GestureDetector(
                onTap: () {
                  updateCounterBy(-1);
                },
                child: Container(
                  color: Theme.of(context).highlightColor,
                  child: const Center(
                      child: Icon(
                    Icons.remove,
                    size: 48,
                  )),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  updateCounterBy(1);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff066e25),
                  ),
                  // color: Theme.of(context).colorScheme.surfaceTint,
                  child: Center(
                      child: Icon(
                    Icons.add,
                    size: 48,
                    color: Theme.of(context).canvasColor,
                  )),
                ),
              ),
            ),
            Obx(() => CustomButton(
                title: 'Save',
                isLoading: _homeController.isLoading.value,
                onPressed: () async {
                  if (counter == 0) {
                    Fluttertoast.showToast(
                        msg: '0 count record can\'t saved !');
                    return;
                  }
                  var recordItem = CounterRecordModel(
                      id: _isUpdate ? widget.counterRecord!.id : Uuid().v1(),
                      counterId: widget.counterModelId,
                      countValue: counter,
                      dateTime: _isUpdate
                          ? widget.counterRecord!.dateTime
                          : DateTime.now());
                  ResponseType response;
                  if (_isUpdate) {
                    response = await _homeController.updateRecord(recordItem);
                  } else {
                    response =
                        await _homeController.addRecordToCounter(recordItem);
                  }
                  Fluttertoast.showToast(msg: response.message);
                  Navigator.of(context).pop();
                }))
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          top: mainHeight * 0.3 - 80,
          child: CircleAvatar(
            // backgroundImage: widget.counterModel. NetworkImage(wind),
            radius: 80,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                '$counter',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
