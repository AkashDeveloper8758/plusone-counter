// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterRecordModelAdapter extends TypeAdapter<CounterRecordModel> {
  @override
  final int typeId = 1;

  @override
  CounterRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CounterRecordModel(
      id: fields[0] as String,
      counterId: fields[1] as String,
      dateTime: fields[2] as DateTime,
      countValue: fields[4] as int,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CounterRecordModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.counterId)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.countValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
