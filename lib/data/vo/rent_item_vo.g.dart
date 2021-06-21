// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_item_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentItemVOAdapter extends TypeAdapter<RentItemVO> {
  @override
  final int typeId = 2;

  @override
  RentItemVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RentItemVO(
      fields[0] as CategoryVO,
      fields[1] as int,
      fields[2] as DateTime,
      fields[3] as DateTime,
      fields[4] as String,
      fields[5] as bool,
      fields[6] as bool,
      fields[7] as bool,
      fields[8] as bool,
      fields[9] as int,
      fields[10] as String,
      fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RentItemVO obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.itemAmount)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.isPrepaid)
      ..writeByte(6)
      ..write(obj.isRent)
      ..writeByte(7)
      ..write(obj.isComplete)
      ..writeByte(8)
      ..write(obj.isHistory)
      ..writeByte(9)
      ..write(obj.totalAmount)
      ..writeByte(10)
      ..write(obj.id)
      ..writeByte(11)
      ..write(obj.prepaidAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentItemVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
