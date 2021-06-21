

import 'package:hive/hive.dart';
import 'package:scaffold_note/persistence/hive_constants.dart';
part 'category_vo.g.dart';

@HiveType(typeId: HIVE_TYPE_ID_CATEGORY_VO,adapterName: 'CategoryVOAdapter')
class CategoryVO{

  @HiveField(0)
  String name;

  @HiveField(1)
  int price;

  @HiveField(2)
  int prepaidPrice;

  @HiveField(3)
  String unit;

  @HiveField(4)
  int minAmount;

  @HiveField(5)
  int maxAmount;

  @HiveField(6)
  String id;

  CategoryVO(this.name, this.price, this.prepaidPrice, this.unit,
      this.minAmount, this.maxAmount, this.id);
}