import 'package:hive/hive.dart';

part 'counter_record_model.g.dart';

@HiveType(typeId: 1)
class CounterRecordModel {
  @HiveField(0)
  final String id;
  // this is counter id on which this record is added.
  @HiveField(1)
  final String counterId;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final int countValue;
  int streakv;
  CounterRecordModel({
    required this.id,
    required this.counterId,
    required this.dateTime,
    required this.countValue,
    this.description,
    this.streakv = 0,
  });

  @override
  bool operator ==(covariant CounterRecordModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.counterId == counterId &&
        other.dateTime == dateTime &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        counterId.hashCode ^
        dateTime.hashCode ^
        description.hashCode;
  }
}
