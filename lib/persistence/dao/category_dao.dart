
import 'package:hive/hive.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/persistence/hive_constants.dart';

class CategoryDao{

  static final CategoryDao _singleton = CategoryDao._internal();
  
  factory CategoryDao(){
    return _singleton;
  }
  
  CategoryDao._internal();
  
  void addCategoryVO(CategoryVO categoryVO){
    getCategoryBox().put(categoryVO.id, categoryVO);
  }

  List<CategoryVO> getAllCategoryVO(){
    return getCategoryBox().values.toList();
  }

  void deleteCategoryVO(String id){
    getCategoryBox().delete(id);
  }

  void deleteAllCategoryVO(){
     getCategoryBox().clear();
  }
  
  
  Box<CategoryVO> getCategoryBox(){
    return Hive.box<CategoryVO>(BOX_NAME_CATEGORY_VO); 
  }
}