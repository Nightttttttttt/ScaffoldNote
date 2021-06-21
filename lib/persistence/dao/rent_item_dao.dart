
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:hive/hive.dart';
import 'package:scaffold_note/persistence/hive_constants.dart';

class RentItemDao{

  static final RentItemDao _singleton = RentItemDao._internal();

  factory RentItemDao(){
    return _singleton;
  }

  RentItemDao._internal();

  void addRentItemVO(RentItemVO rentItemVO){
    getRentItemBox().put(rentItemVO.id, rentItemVO);
  }

  List<RentItemVO> getAllRentItemVO(){
    return getRentItemBox().values.toList();
  }

  RentItemVO getRentItemVO(String id){
    return getRentItemBox().get(id);
  }

  void clearAllRentItemVO(){
    getRentItemBox().clear();
  }

  void deleteCompleteItemVO(String id){
    getRentItemBox().delete(id);
  }


  Box<RentItemVO> getRentItemBox(){
    return Hive.box<RentItemVO>(BOX_NAME_RENT_ITEM_VO);
  }

}