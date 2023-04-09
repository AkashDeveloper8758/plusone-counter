// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:plusone_counter/feature/home/screens/add_counter_detail_screen.dart';
import 'package:plusone_counter/feature/home/screens/counter_detail_screen.dart';
import 'package:plusone_counter/feature/home/screens/home.dart';
import 'package:plusone_counter/feature/home/screens/record_add_screen.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';

abstract class RouteName {
  static const String addCounterScreen = '/addCounterScreen';
  static const String counterDetailScreen = '/counterDetailScreen';
  static const String counterRecordScreen = '/counterScreen';
  RouteName._();
}

class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final route = settings.name;
    final arguments = settings.arguments;

    switch (route) {
      case '/':
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
          // builder: (BuildContext context) => AddCounterScreen(),
        );

      case RouteName.addCounterScreen:
        var counterModel = settings.arguments as CounterModel?;
        return MaterialPageRoute(
          builder: (BuildContext context) => CreateCounterScreen(
            counterModel: counterModel,
          ),
        );
      case RouteName.counterRecordScreen:
        var counterArgs = settings.arguments as CounterRecordArgs;
        return MaterialPageRoute(
          builder: (BuildContext context) => CounterScreen(
            counterModel: counterArgs.counterModel,
            counterRecord: counterArgs.counterRecordModel,
          ),
        );
      case RouteName.counterDetailScreen:
        var counterModel = settings.arguments as CounterModel;
        return MaterialPageRoute(
          builder: (BuildContext context) => CounterRecordDetailScreen(
            counterModel: counterModel,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        );
    }
  }
}

class CounterRecordArgs {
  CounterModel counterModel;
  CounterRecordModel? counterRecordModel;
  CounterRecordArgs({
    required this.counterModel,
    this.counterRecordModel,
  });
}
