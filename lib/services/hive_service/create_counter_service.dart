import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:plusone_counter/model/counter_model.dart';
import 'package:plusone_counter/model/counter_record_model.dart';

import '../../utils/helper_classes/response.dart';

class CreateCounterServiceHelper {
  Box<CounterModel> counterBox;
  CreateCounterServiceHelper(this.counterBox);

  Future<ResponseType> addCounter(CounterModel counter) async {
    try {
      await counterBox.put(counter.id, counter);
      return ResponseType(status: true, message: 'Data Added successfully');
    } catch (err) {
      return ResponseType(status: false, message: 'Adding counter failed !');
    }
  }

  Future<ResponseType> removeCounter(CounterModel counter) async {
    try {
      await counterBox.delete(counter.id);
      return ResponseType(status: true, message: 'Data Deleted successfully');
    } catch (err) {
      return ResponseType(status: false, message: 'Delete counter failed !');
    }
  }

  Future<ResponseType> updateCounter(CounterModel counter) async {
    try {
      await counterBox.put(counter.id, counter);
      return ResponseType(status: true, message: 'Data Deleted successfully');
    } catch (err) {
      return ResponseType(status: false, message: 'Delete counter failed !');
    }
  }

  Future<ResponseType> updateRecord(CounterRecordModel recordModel) async {
    try {
      var counterModel = counterBox.get(recordModel.counterId);
      if (counterModel != null) {
        var recordModelsIndex = counterModel.counterRecords
            .indexWhere((element) => element.id == recordModel.id);

        counterModel.counterRecords[recordModelsIndex] = recordModel;
        await counterBox.put(recordModel.counterId, counterModel);
        return ResponseType(status: true, message: 'Record updated');
      } else {
        return ResponseType(status: false, message: 'Record not found');
      }
    } catch (err) {
      return ResponseType(status: false, message: 'Delete counter failed !');
    }
  }

  Future<ResponseType> addRecordToCounter(
      CounterRecordModel counterRecordModel) async {
    try {
      var counterId = counterRecordModel.counterId;
      var counterItem = counterBox.get(counterId);
      log('counter keys: ${counterBox.keys} ');
      log('my keys: ${counterId} ');

      if (counterItem != null) {
        counterItem.counterRecords.add(counterRecordModel);
        await counterBox.put(counterId, counterItem);
        return ResponseType(status: true, message: 'Record added successfully');
      } else {
        return ResponseType(status: false, message: 'Record not found');
      }
    } catch (err) {
      return ResponseType(status: false, message: 'Record add failed !');
    }
  }

  Future<ResponseType<List<CounterRecordModel>>> getCounterRecordById(
      String counterId) async {
    try {
      var counterItem = counterBox.get(counterId);
      if (counterItem != null) {
        return ResponseType(
            status: true,
            data: counterItem.counterRecords,
            message: 'Record found');
      } else {
        return ResponseType(status: false, message: 'Record not found');
      }
    } catch (err) {
      return ResponseType(status: false, message: 'Record get failed !');
    }
  }

  ResponseType<List<CounterModel>> getAllCounters() {
    try {
      var countersList = counterBox.values.toList();
      return ResponseType(
          status: true, data: countersList, message: 'Data received');
    } catch (err) {
      return ResponseType(
          status: false,
          data: [],
          message: 'Failed to get all counters list !');
    }
  }

  Future<ResponseType> clearAllCounters() async {
    try {
      await counterBox.clear();
      return ResponseType(status: true, message: 'All Counters cleared');
    } catch (err) {
      return ResponseType(
          status: false,
          data: [],
          message: 'Failed to get all counters list !');
    }
  }
}
