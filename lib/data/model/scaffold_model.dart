

import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';

abstract class ScaffoldModel{
  List<CategoryVO> getAllCategoryFromDatabase();
  void addCategoryToDatabase(CategoryVO categoryVO);
  void deleteCategory(String id);
  void deleteAllCategoryFromDatabase();

  List<RentItemVO> getAllRentItemFromDatabase();
  List<RentItemVO> getAllCompleteItemFromDatabase();
  List<RentItemVO> getAllHistoryItemFromDatabase();
  void addRentItemToDatabase(RentItemVO rentItemVO);
  RentItemVO getRentItemFromDatabase(String id);
  void updateRentItemToComplete(String id,DateTime endDate);
  void updateCompleteItemToHistory(String id);
  void deleteCompleteItem(String id);
  void clearAllRentItemFromDatabase();
}