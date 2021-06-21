import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/model/scaffold_model_impl.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/pages/add_item_page.dart';
import 'package:scaffold_note/pages/calendar_page.dart';
import 'package:scaffold_note/pages/category_page.dart';
import 'package:scaffold_note/pages/rent_item_details.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';
import 'package:scaffold_note/resources/strings.dart';
import 'package:scaffold_note/views/rent_item_view.dart';
import 'package:scaffold_note/views/sticky_delegate.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> headerList = ['Rent', 'Complete'];
  Color tempColor = Colors.grey;
  ScaffoldModel mScaffoldModel = ScaffoldModelImpl();
  List<RentItemVO> rentItemList;
  List<CategoryVO> categoryList;
  int currentIndex = 0;
  String test;

  @override
  void initState() {
    super.initState();

    rentItemList =
        mScaffoldModel.getAllRentItemFromDatabase();
    categoryList = mScaffoldModel.getAllCategoryFromDatabase();

    //mScaffoldModel.deleteAllCategoryFromDatabase();
    // CategoryVO categoryVO = CategoryVO('တီတိုင်', 50, 40, 'ချောင်း', 0,500,getUniqueId());
    // mScaffoldModel.addCategoryToDatabase(categoryVO);
    // categoryVO = CategoryVO('ဂျပန်ငြမ်း', 500, 400, 'ခု', 0,500,getUniqueId());
    // mScaffoldModel.addCategoryToDatabase(categoryVO);
    // print('complete insertion');
  }


  void initializeList(){
    if(currentIndex == 0){
      setState(() {
        rentItemList = mScaffoldModel.getAllRentItemFromDatabase();
      });
    }else if(currentIndex == 1){
      setState(() {
        rentItemList = mScaffoldModel.getAllCompleteItemFromDatabase();
      });

    }else{
      setState(() {
        rentItemList = mScaffoldModel.getAllHistoryItemFromDatabase();
      });
    }
  }

  String getUniqueId(){
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddItemPage();
              },
            ),
          );

          initializeList();

        },
        child: const Icon(Icons.add),
      ),
      backgroundColor: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBarSectionView(
              calendarOnTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CalendarPage();
                }));
              },
              categoryOnTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return CategoryPage();
                }));
              },
            ),
            SliverPersistentHeader(
              delegate: StickyDelegate(headerList, (index) {
                if (index == 0) {
                  currentIndex = 0;
                  setState(() {
                    rentItemList = mScaffoldModel.getAllRentItemFromDatabase();
                  });
                } else if (index == 1) {
                  currentIndex = 1;
                  setState(() {
                    rentItemList = mScaffoldModel.getAllCompleteItemFromDatabase();
                  });
                } else {
                  currentIndex = 2;
                  setState(() {
                    rentItemList = mScaffoldModel.getAllHistoryItemFromDatabase();
                  });
                }
              }),
              pinned: true,
              floating: true,
            ),
            SliverFixedExtentList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                        onTap: () async{
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RentItemDetails(rentItemList[index]);
                              },
                            ),
                          );
                          initializeList();
                        },
                        child: RentItemView(rentItemList[index]));
                  },
                  childCount: rentItemList.length,
                ),
                itemExtent: 100)
          ],
        ),
      ),
    );
  }
}

class SliverAppBarSectionView extends StatelessWidget {
  final Function calendarOnTap;
  final Function categoryOnTap;

  SliverAppBarSectionView({@required this.calendarOnTap, @required this.categoryOnTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      collapsedHeight: MediaQuery.of(context).size.height * 0.22,
      backgroundColor: Colors.white,
      flexibleSpace: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.22,
        margin: EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_3X, vertical: MARGIN_MEDIUM_2X),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: (){
                    calendarOnTap();
                  },
                  child: Container(
                    width: 120,
                    height: MARGIN_XLARGE,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(MARGIN_MEDIUM_3X),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 1),
                          blurRadius: MARGIN_SMALL,
                          //spreadRadius: MARGIN_SMALL,
                        )
                      ]
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.white,
                          ),
                          SizedBox(width: MARGIN_MEDIUM),
                          Text(
                            'Calendar',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: MARGIN_MEDIUM_2X),
                GestureDetector(
                  onTap: (){
                    categoryOnTap();
                  },
                  child: CircularIcon(
                    Icons.settings,
                    MARGIN_MEDIUM_2X,
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shadowColor: Colors.black45,
                  ),
                ),
              ],
            ),
            SizedBox(height: MARGIN_MEDIUM),
            Text(
              HOME_PAGE_BOARDS_TEXT,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: TEXT_HEADER_2X,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MARGIN_MEDIUM),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
                borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: HOME_PAGE_SEARCH_PERSON_TEXT,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: TEXT_REGULAR_2X,
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircularIcon extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final Color shadowColor;

  CircularIcon(this.iconData, this.size,
      {@required this.iconColor,
      @required this.backgroundColor,
      @required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MARGIN_LARGE + MARGIN_SMALL,
      height: MARGIN_LARGE + MARGIN_SMALL,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(0, 1),
              blurRadius: MARGIN_SMALL,
              //spreadRadius: MARGIN_SMALL,
            )
          ]),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: size,
        ),
      ),
    );
  }
}
