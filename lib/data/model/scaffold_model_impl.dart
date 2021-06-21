
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/persistence/dao/category_dao.dart';
import 'package:scaffold_note/persistence/dao/rent_item_dao.dart';

class ScaffoldModelImpl extends ScaffoldModel{
  CategoryDao mCategoryDao = CategoryDao();
  RentItemDao mRentItemDao = RentItemDao();

  @override
  void addCategoryToDatabase(CategoryVO categoryVO) {
    mCategoryDao.addCategoryVO(categoryVO);
  }

  @override
  List<CategoryVO> getAllCategoryFromDatabase() {
    return mCategoryDao.getAllCategoryVO();
  }

  @override
  void deleteCategory(String id) {
    return mCategoryDao.deleteCategoryVO(id);
  }

  @override
  void deleteAllCategoryFromDatabase() {
    return mCategoryDao.deleteAllCategoryVO();
  }


  @override
  void addRentItemToDatabase(RentItemVO rentItemVO) {
    rentItemVO.isRent = true;
    rentItemVO.isComplete = false;
    rentItemVO.isHistory = false;
    mRentItemDao.addRentItemVO(rentItemVO);
  }


  @override
  RentItemVO getRentItemFromDatabase(String id) {
    return mRentItemDao.getRentItemVO(id);
  }

  @override
  List<RentItemVO> getAllRentItemFromDatabase() {
    return mRentItemDao.getAllRentItemVO().where((item) => item.isRent ?? true).toList();
  }


  @override
  List<RentItemVO> getAllCompleteItemFromDatabase() {
    return mRentItemDao.getAllRentItemVO().where((item) => item.isComplete ?? true).toList();
  }

  @override
  List<RentItemVO> getAllHistoryItemFromDatabase() {
    return mRentItemDao.getAllRentItemVO().where((item) => item.isHistory ?? true).toList();
  }

  @override
  void updateCompleteItemToHistory(String id) {
    RentItemVO rentItemVO = mRentItemDao.getRentItemVO(id);
    rentItemVO.isRent = false;
    rentItemVO.isComplete = false;
    rentItemVO.isHistory = true;
    mRentItemDao.addRentItemVO(rentItemVO);
  }

  @override
  void updateRentItemToComplete(String id, DateTime endDate) {
    RentItemVO rentItemVO = mRentItemDao.getRentItemVO(id);
    rentItemVO.isRent = false;
    rentItemVO.isComplete = true;
    rentItemVO.isHistory = false;
    rentItemVO.endDate = endDate;
    mRentItemDao.addRentItemVO(rentItemVO);
  }

  @override
  void clearAllRentItemFromDatabase() {
    mRentItemDao.clearAllRentItemVO();
  }

  @override
  void deleteCompleteItem(String id) {
    mRentItemDao.deleteCompleteItemVO(id);
  }





}