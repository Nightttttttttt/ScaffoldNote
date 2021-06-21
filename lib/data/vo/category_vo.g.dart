// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_vo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryVOAdapter extends TypeAdapter<CategoryVO> {
  @override
  final int typeId = 1;

  @override
  CategoryVO read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryVO(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
      fields[3] as String,
      fields[4] as int,
      fields[5] as int,
      fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryVO obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.prepaidPrice)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.minAmount)
      ..writeByte(5)
      ..write(obj.maxAmount)
      ..writeByte(6)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryVOAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
