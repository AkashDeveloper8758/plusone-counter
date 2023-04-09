import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plusone_counter/feature/home/widget/counter_item_widget.dart';
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
  bool _isDeleteActive = true;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.getAllCounterModels();
    });
    super.initState();
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
              child: Text('Home page'))),
      body: Obx(
        () {
          var counterList = _homeController.getCountersList;
          counterList.sort((a, b) => b.createDate.compareTo(a.createDate));
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: ListView.builder(
                itemCount: counterList.length,
                itemBuilder: (context, index) {
                  return CounterWidget(
                    counterModel: counterList[index],
                    onDeleteClick: () {
                      _homeController.removeCounterModel(counterList[index]);
                    },
                  );
                },
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
