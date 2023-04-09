import 'package:hive/hive.dart';
import 'package:plusone_counter/model/counter_record_model.dart';

part 'counter_model.g.dart';

@HiveType(typeId: 0)
class CounterModel {
  @HiveField(0)
  final String counterTitle;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final DateTime createDate;
  @HiveField(3)
  List<CounterRecordModel> counterRecords;
  @HiveField(4)
  final int? dailyGoal;

  CounterModel({
    required this.id,
    required this.createDate,
    this.counterTitle = '',
    this.counterRecords = const [],
    this.dailyGoal,
  });

  @override
  bool operator ==(covariant CounterModel other) {
    if (identical(this, other)) return true;

    return other.counterTitle == counterTitle &&
        other.id == id &&
        other.createDate == createDate;
  }

  @override
  int get hashCode => counterTitle.hashCode ^ id.hashCode ^ createDate.hashCode;
}
