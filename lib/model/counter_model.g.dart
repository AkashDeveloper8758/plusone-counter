// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterModelAdapter extends TypeAdapter<CounterModel> {
  @override
  final int typeId = 0;

  @override
  CounterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CounterModel(
      id: fields[1] as String,
      createDate: fields[2] as DateTime,
      counterTitle: fields[0] as String,
      counterRecords: (fields[3] as List).cast<CounterRecordModel>(),
      dailyGoal: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CounterModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.counterTitle)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.createDate)
      ..writeByte(3)
      ..write(obj.counterRecords)
      ..writeByte(4)
      ..write(obj.dailyGoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
