import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/utils/custom_components/custom_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uuid/uuid.dart';

import '../../../controllers/home_controllers.dart';
import '../../../utils/helper_classes/helper_function.dart';
import '../../../utils/helper_classes/response.dart';

class CounterScreen extends StatefulWidget {
  final CounterModel counterModel;
  final CounterRecordModel? counterRecord;
  const CounterScreen(
      {super.key, required this.counterModel, this.counterRecord});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  final HomeController _homeController = Get.find();
  int counter = 0;
  bool _isUpdate = false;
  List<int> incrementalsList = [-10, -50, 10, 50];
  updateCounterBy(int value) async {
    await _playTickAudio(value.abs() > 1 ? highAudioAsset : lowAudioAsset);
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
  String highAudioAsset = 'music/click_effect-86995.mp3';
  String lowAudioAsset = 'music/light-switch-81967.mp3';

  _playTickAudio(String asset) async {
    AudioPlayer player = AudioPlayer();
    await player.play(AssetSource(asset));
  }

  @override
  Widget build(BuildContext context) {
    int? dailyGoal = widget.counterModel.dailyGoal;
    double mainHeight = Get.height - Get.statusBarHeight;
    Color primaryBackground = Color(0xff49A078);
    double percentage = 0;
    if (dailyGoal != null) {
      percentage = ((counter) / widget.counterModel.dailyGoal!);
      if (percentage > 1) percentage = 1;
    }
    String percentageString = "";
    List<TextSpan> richChildrens = [];
    if (dailyGoal != null) {
      richChildrens.add(TextSpan(
          text:
              "${((counter / widget.counterModel.dailyGoal!) * 100).round()} % ",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: percentage == 1 ? Theme.of(context).primaryColor : null)));
      richChildrens.add(TextSpan(text: "| 🎯 $dailyGoal"));
    }
    RichText richPercentageText = RichText(
        text: TextSpan(
            text: '',
            children: richChildrens,
            style: Theme.of(context).textTheme.titleMedium));

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
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                onTap: () async {
                  updateCounterBy(1);
                },
                child: Container(
                  decoration: BoxDecoration(
                    // color: Color(0xff066e25),
                    color: primaryBackground,
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Wrap(
                children: incrementalsList.map((e) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                        onPressed: () {
                          updateCounterBy(e);
                        },
                        child: Text(' ${e > 0 ? "+" : "-"} ${e.abs()}')),
                  );
                }).toList(),
              ),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                      title: 'Save',
                      isLoading: _homeController.isLoading.value,
                      onPressed: () async {
                        if (counter == 0) {
                          Fluttertoast.showToast(
                              msg: '0 count record can\'t saved !');
                          return;
                        }
                        if (counter > (dailyGoal ?? double.infinity) * 20) {
                          Fluttertoast.showToast(
                              msg:
                                  'your count is more then 20x times the daily goal');
                          return;
                        }
                        var recordItem = CounterRecordModel(
                            id: _isUpdate
                                ? widget.counterRecord!.id
                                : Uuid().v1(),
                            counterId: widget.counterModel.id,
                            countValue: counter,
                            dateTime: _isUpdate
                                ? widget.counterRecord!.dateTime
                                : DateTime.now());
                        ResponseType response;
                        if (_isUpdate) {
                          response =
                              await _homeController.updateRecord(recordItem);
                        } else {
                          response = await _homeController
                              .addRecordToCounter(recordItem);
                        }
                        Fluttertoast.showToast(msg: response.message);
                        Navigator.of(context).pop();
                      }),
                ))
          ],
        ),
        if (dailyGoal != null)
          Positioned(
              right: 0,
              top: mainHeight * 0.3 - 28,
              child: Container(
                height: 56,
                padding: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerRight,
                width: Get.width * 0.5,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.surface),
                child: richPercentageText,
              )),
        Positioned(
            left: 0,
            right: 0,
            top: mainHeight * 0.3 - 80,
            child: CircularPercentIndicator(
              radius: 75.0,
              lineWidth: 15.0,
              percent: percentage,
              center: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                child: Text(
                  '$counter',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              animation: true,
              animationDuration: 500,
              animateFromLastPercent: true,
              curve: Curves.easeInOut,
              progressColor: percentage < 1
                  ? primaryBackground
                  : Theme.of(context).primaryColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
            )),
      ])),
    );
  }
}
