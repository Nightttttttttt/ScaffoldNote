
import 'package:hive/hive.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/persistence/hive_constants.dart';
part 'rent_item_vo.g.dart';

@HiveType(typeId: HIVE_TYPE_ID_RENT_ITEM_VO,adapterName: 'RentItemVOAdapter')
class RentItemVO{

  @HiveField(0)
  CategoryVO category;

  @HiveField(1)
  int itemAmount;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  @HiveField(4)
  String note;

  @HiveField(5)
  bool isPrepaid;

  @HiveField(6)
  bool isRent;

  @HiveField(7)
  bool isComplete;

  @HiveField(8)
  bool isHistory;

  @HiveField(9)
  int totalAmount;

  @HiveField(10)
  String id;

  @HiveField(11)
  String prepaidAmount;

  RentItemVO(
      this.category,
      this.itemAmount,
      this.startDate,
      this.endDate,
      this.note,
      this.isPrepaid,
      this.isRent,
      this.isComplete,
      this.isHistory,
      this.totalAmount,
      this.id,
      this.prepaidAmount);
}