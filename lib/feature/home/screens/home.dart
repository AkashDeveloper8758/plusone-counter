import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/feature/home/widget/counter_item_widget.dart';
import 'package:plusone_counter/utils/constants/assets.dart';
import 'package:plusone_counter/utils/custom_components/center_message_widget.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/initials/app_routes.dart';

import '../../../controllers/home_controllers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.find();
  bool _isDeleteActive = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.getAllCounterModels();
      showImageDialog();
    });
    super.initState();
  }

  showImageDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(HelperFunction.getRandomMotivationalImage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            if (_isDeleteActive) {
              var response = await HelperFunction.showConfromationDialogBox(
                  'In Develpment : are you sure to delete all countes',
                  context);
              if (response) {
                await _homeController.clearAllCounters();
              }
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(AppAssets.appIconWithBackgrund),
              ),
              SizedBox(width: 8),
              Text('Plus One Habit ',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showImageDialog();
              },
              icon: Icon(Icons.ac_unit_sharp))
        ],
      ),
      body: Obx(
        () {
          var counterList = _homeController.getCountersList;
          counterList.sort((a, b) => b.createDate.compareTo(a.createDate));
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  counterList.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: counterList.length,
                            itemBuilder: (context, index) {
                              return CounterWidget(
                                counterModel: counterList[index],
                                onClearRecordsClicked: () async {
                                  var conformationResponse = await HelperFunction
                                      .showConfromationDialogBox(
                                          'Are you sure, to delete all records of this counter ?',
                                          context);
                                  if (conformationResponse) {
                                    counterList[index].counterRecords.clear();
                                    _homeController
                                        .updateCounterModel(counterList[index]);
                                    Fluttertoast.showToast(
                                        msg: 'All Records are cleared');
                                  }
                                },
                                onDeleteClick: () {
                                  _homeController
                                      .removeCounterModel(counterList[index]);
                                },
                              );
                            },
                          ),
                        )
                      : CenterMessageWidget(
                          additionalWidget: Column(
                            children: [
                              Image.network(AppAssets.rotatingAnimal),
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 72,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(RouteName.addCounterScreen);
                                },
                              ),
                            ],
                          ),
                          centerTitle:
                              'Click on + plus icon to create your countings'),
                  if (counterList.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 56,
                        child: Image.network(AppAssets.transparentFire),
                      ),
                    )
                ],
              ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.addCounterScreen);
        },
        label: Text('Add Counting'),
      ),
    );
  }
}
