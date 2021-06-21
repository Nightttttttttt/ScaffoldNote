
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/model/scaffold_model_impl.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';
import 'package:scaffold_note/resources/strings.dart';
import 'package:scaffold_note/views/based_card_view.dart';
import 'package:scaffold_note/views/card_drop_down_view.dart';
import 'package:scaffold_note/views/close_button_view.dart';
import 'package:scaffold_note/views/dim_buttton_view.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  List<String> categoryItem;
  List<CategoryVO> categoryList;
  String chosenItem;
  String chosenDate;
  String prePaidAmount = '';
  DateTime userPicked;
  List<String> months = ['Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'];
  DateTime today = DateTime.now();
  String noteText;
  double sliderItemCount = 100;
  int minAmount;
  int maxAmount;
  bool isPrepaid = false;
  ScaffoldModel mScaffoldModel = ScaffoldModelImpl();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(2021, 1, 1),
      initialDate: today,
      lastDate: DateTime.utc(2100, 12, 31),
    );
    if (picked != null) {
      setState(() {
        chosenDate = dateTimeToReadableFormat(picked);
      });
      userPicked = picked;
      print(userPicked);
    }
  }

  String dateTimeToReadableFormat(DateTime dateTime){
    return '${months[dateTime.month - 1]} ${dateTime.day} ${dateTime.year}';
  }

  String getUniqueId(){
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  void saveRentItemVO(){
    RentItemVO rentItem = RentItemVO(categoryList[categoryItem.indexOf(chosenItem)], sliderItemCount.round(), userPicked, null, noteText, isPrepaid, true, false, false, 0, getUniqueId(),prePaidAmount != '' ? prePaidAmount : '0');
    mScaffoldModel.addRentItemToDatabase(rentItem);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      // Initialize Category
      categoryList = mScaffoldModel.getAllCategoryFromDatabase();
      categoryItem = categoryList.map((category) => category.name).toList();
      chosenItem = categoryItem[0];

      // Initialize Date
      chosenDate = dateTimeToReadableFormat(today);
      userPicked = today;

      // Initialize max & min bound
      maxAmount = categoryList[categoryItem.indexOf(chosenItem)].maxAmount;
      minAmount = categoryList[categoryItem.indexOf(chosenItem)].minAmount;
      sliderItemCount = maxAmount * 0.1 ;


    });

  }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2X),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MARGIN_MEDIUM_3X),
                  Row(
                    children: [
                      Spacer(),
                      CloseButtonView(
                            () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: MARGIN_MEDIUM_3X),
                  CategoryCard(
                      categoryItem: categoryItem,
                      chosenItem: chosenItem,
                      chosenDate: chosenDate,
                      onItemChange: (value) {
                        setState(() {
                          chosenItem = value;

                          // Initialize max & min bound
                          maxAmount = categoryList[categoryItem.indexOf(chosenItem)].maxAmount;
                          minAmount = categoryList[categoryItem.indexOf(chosenItem)].minAmount;
                          sliderItemCount = maxAmount * 0.1;
                        });
                      },
                      onItemTap: () {

                      },
                      onDateTap: () {

                        _selectDate(context);
                      }),
                  SizedBox(height: MARGIN_MEDIUM),
                  NoteCard(
                    onChanged: (value){
                      noteText = value;
                    },
                  ),
                  SizedBox(height: MARGIN_MEDIUM),
                  SliderCard(
                      minimum: minAmount,
                      maximum: maxAmount,
                      sliderItemCount: sliderItemCount,
                      onIncreaseCount: () {
                        if(sliderItemCount < maxAmount){
                          setState(() {
                            sliderItemCount += 1;
                          });
                        }
                      },
                      onDecreaseCount: ()  {
                        if(sliderItemCount > minAmount){
                          setState(() {
                            sliderItemCount -= 1;
                          });
                        }
                      },
                      onSliderChanged: (value) {
                        setState(() {
                          sliderItemCount = value;
                        });
                      }),
                  SizedBox(height: MARGIN_MEDIUM),
                  PriceCard(categoryList[categoryItem.indexOf(chosenItem)],isPrepaid, prepaidOnChanged: (value){
                    prePaidAmount = value;
                   // print(prePaidAmount);
                  },
                  isPrepaidOnChanged: (value){
                    setState(() {
                      isPrepaid = value;

                    });
                  },
                  ),
                  SizedBox(height: MARGIN_MEDIUM),


                  Padding(
                    padding: EdgeInsets.only(bottom: MARGIN_MEDIUM),
                    child: Row(
                      children: [
                        Expanded(
                            child: DimButtonView(
                                ADD_ITEM_PAGE_CATEGORY_CARD_COLOR, ADD_ITEM_PAGE_ADD_TEXT,
                                onTap: (){
                                  saveRentItemVO();

                                },),),
                        SizedBox(width: MARGIN_MEDIUM_2X),
                        Expanded(
                            child: DimButtonView(
                                ADD_ITEM_DELETE_BACKGROUND_COLOR, ADD_ITEM_PAGE_DELETE_TEXT,textColor: ADD_ITEM_DELETE_TEXT_COLOR,
                                onTap: (){
                                  mScaffoldModel.clearAllRentItemFromDatabase();
                                  Navigator.pop(context);
                                },
                            ),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class PriceCard extends StatelessWidget {
  final Function(String) prepaidOnChanged;
  final Function(bool) isPrepaidOnChanged;
  final CategoryVO categoryVO;
  final bool isPrepaid;

  PriceCard(this.categoryVO,this.isPrepaid,{ @required this.prepaidOnChanged,@required this.isPrepaidOnChanged});
  @override
  Widget build(BuildContext context) {
    return BasedCardView(height: ADD_ITEM_PAGE_PRICE_CARD_HEIGHT, color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR, child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              RENT_DETAILS_PAGE_PREPAID_TEXT,
              style: TextStyle(
                color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Container(
              width: 150.0,
              height: MARGIN_XLARGE,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: '0.0',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: TEXT_REGULAR_3X,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value){
                    prepaidOnChanged(value);
                  },
                ),
              ),
            ),
          ],
        ),
        CheckboxListTile(
          contentPadding: EdgeInsets.all(0),
            value: isPrepaid,
            title: Text(
                '$ADD_ITEM_PAGE_DISCOUNT_TEXT (${categoryVO.prepaidPrice} kyats)',
              style: TextStyle(
                color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (value) {
            isPrepaidOnChanged(value);

            }),


      ],
    ),);
  }
}


class SliderCard extends StatelessWidget {
  final minimum;
  final maximum;
  final sliderItemCount;
  final Function onIncreaseCount;
  final Function onDecreaseCount;
  final Function(double value) onSliderChanged;

  SliderCard(
      {@required this.minimum,
        @required this.maximum,
        @required this.sliderItemCount,
      @required this.onIncreaseCount,
      @required this.onDecreaseCount,
      @required this.onSliderChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2X, vertical: MARGIN_MEDIUM),
      width: MediaQuery.of(context).size.width,
      height: ADD_ITEM_PAGE_SLIDER_CARD_HEIGHT,
      decoration: BoxDecoration(
          color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(sliderItemCount.round().toString() + ' units'),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  onDecreaseCount();
                },
                child: Icon(
                  Icons.remove,
                  size: MARGIN_LARGE,
                ),
              ),
              Expanded(
                child: Slider(
                  value: sliderItemCount,
                  min: double.parse(minimum.toString()),
                  max: double.parse(maximum.toString()),
                  onChanged: (value) {
                    onSliderChanged(value);
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  onIncreaseCount();
                },
                child: Icon(
                  Icons.add,
                  size: MARGIN_LARGE,
                ),
              ),
            ],
          ),
          SizedBox(height: MARGIN_MEDIUM_2X),

        ],
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Function(String value) onChanged;


  NoteCard({@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2X, vertical: MARGIN_MEDIUM),
      width: MediaQuery.of(context).size.width,
      height: ADD_ITEM_PAGE_NOTE_CARD_HEIGHT,
      decoration: BoxDecoration(
          color: ADD_ITEM_PAGE_NOTE_CARD_COLOR,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X)),
      child: TextField(
        maxLines: 12,
        minLines: 1,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'Write a note...',
            hintStyle: TextStyle(
              color: ADD_ITEM_PAGE_NOTE_TEXT_COLOR,
              fontSize: TEXT_REGULAR_3X,
            ),),
        onChanged: (value){
          onChanged(value);

        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final List<String> categoryItem;
  final String chosenItem;
  final String chosenDate;
  final Function onItemTap;
  final Function onDateTap;
  final Function(String value) onItemChange;

  CategoryCard(
      {@required this.categoryItem,
      @required this.chosenItem,
      @required this.chosenDate,
      @required this.onItemChange,
      this.onItemTap,
      @required this.onDateTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2X, vertical: MARGIN_MEDIUM),
      width: MediaQuery.of(context).size.width,
      height: ADD_ITEM_PAGE_CATEGORY_CARD_HEIGHT,
      decoration: BoxDecoration(
          color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                ADD_ITEM_PAGE_CATEGORY_TEXT,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              CardDropDownView(
                itemList: categoryItem,
                iconData: Icons.add,
                chosenItem: chosenItem,
                onChanged: (value) {
                  onItemChange(value);
                },
                onTap: () {
                  onItemTap();
                },
              ),
            ],
          ),
          SizedBox(height: MARGIN_MEDIUM),
          Row(
            children: [
              Text(
                ADD_ITEM_PAGE_DUE_DATE_TEXT,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  onDateTap();
                },
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(MARGIN_MEDIUM + MARGIN_SMALL)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MARGIN_MEDIUM_2X,
                        vertical: MARGIN_MEDIUM_2X),
                    child:
                        DropDownContentView(Icons.calendar_today, chosenDate),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
