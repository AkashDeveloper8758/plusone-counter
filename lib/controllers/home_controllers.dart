import 'dart:developer';
import 'dart:math';

import 'package:get/get.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';
import 'package:plusone_counter/services/hive_service/hive_service.dart';
import 'package:plusone_counter/utils/helper_classes/helper_function.dart';
import 'package:plusone_counter/utils/helper_classes/response.dart';

class HomeController extends GetxController {
  late HiveService _hiveService;
  HomeController(HiveService hiveService) {
    _hiveService = hiveService;
  }
  RxBool isLoading = false.obs;
  List<CounterModel> get getCountersList => _countersModels.toList();
  final RxList<CounterModel> _countersModels = RxList.empty();

  Future<ResponseType> addCounterModel(CounterModel counterModel) async {
    isLoading.value = true;
    var response =
        await _hiveService.createCounterServiceHelper.addCounter(counterModel);
    if (response.status) {
      _countersModels.add(counterModel);
    }
    isLoading.value = false;
    return response;
  }

  Future<ResponseType> removeCounterModel(CounterModel counterModel) async {
    isLoading.value = true;
    var response = await _hiveService.createCounterServiceHelper
        .removeCounter(counterModel);
    if (response.status) {
      _countersModels.remove(counterModel);
    }
    isLoading.value = false;
    return response;
  }

  Future<ResponseType> updateCounterModel(CounterModel counterModel) async {
    isLoading.value = true;
    var response = await _hiveService.createCounterServiceHelper
        .updateCounter(counterModel);
    _countersModels[_countersModels
        .indexWhere((e) => e.id == counterModel.id)] = counterModel;
    isLoading.value = false;
    return response;
  }

  getAllCounterModels() {
    var response = _hiveService.createCounterServiceHelper.getAllCounters();
    if (response.status) {
      _countersModels.clear();
      _countersModels.addAll(response.data ?? []);
    }
  }

  Future<ResponseType> addRecordToCounter(CounterRecordModel recordItem) async {
    isLoading.value = true;
    late ResponseType response;
    response = await _hiveService.createCounterServiceHelper
        .addRecordToCounter(recordItem);

    _countersModels.refresh();
    isLoading.value = false;
    return response;
  }

  List<CounterRecordModel> getRecordByCounter(String counterId) {
    var records = _countersModels
        .firstWhere((element) => element.id == counterId)
        .counterRecords
        .toList();
    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    records = HelperFunction.fillStreakValue(records);
    return records;
  }

  Future<ResponseType> removeRecord(CounterRecordModel record) async {
    var counterModel =
        _countersModels.firstWhere((element) => element.id == record.counterId);
    counterModel.counterRecords.remove(record);
    var response = await _hiveService.createCounterServiceHelper
        .updateCounter(counterModel);
    _countersModels.refresh();
    return response;
  }

  Future<ResponseType> updateRecord(CounterRecordModel record) async {
    var response =
        await _hiveService.createCounterServiceHelper.updateRecord(record);
    _countersModels.refresh();
    return response;
  }

  clearAllCounters() async {
    await _hiveService.createCounterServiceHelper.clearAllCounters();
    _countersModels.clear();
  }
}
