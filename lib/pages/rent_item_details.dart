import 'package:flutter/material.dart';
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/model/scaffold_model_impl.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/pages/add_item_page.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';
import 'package:scaffold_note/resources/strings.dart';
import 'package:scaffold_note/views/based_card_view.dart';
import 'package:scaffold_note/views/card_drop_down_view.dart';
import 'package:scaffold_note/views/close_button_view.dart';
import 'package:scaffold_note/views/dim_buttton_view.dart';

class RentItemDetails extends StatefulWidget {
  final RentItemVO rentItem;

  RentItemDetails(this.rentItem);

  @override
  _RentItemDetailsState createState() => _RentItemDetailsState();
}

class _RentItemDetailsState extends State<RentItemDetails> {
  DateTime today = DateTime.now();
  DateTime userPicked;
  String itemName = 'Book x 50';
  String startDate = 'Oct 15 2021';
  String endDate = 'Dec 15 2021';
  String totalAmount = '';
  String prepaidAmount = '';
  String remainingAmount = '';
  int total;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  bool isPrepaid = false;
  var noteTextEditingController = TextEditingController();
  var prepaidTextEditingController = TextEditingController();
  ScaffoldModel mScaffoldModel = ScaffoldModelImpl();

  String dateTimeToReadableFormat(DateTime dateTime) {
    return '${months[dateTime.month - 1]} ${dateTime.day} ${dateTime.year}';
  }

  String getDayDifference() {
    DateTime today = DateTime.now();
    Duration difference = today.difference(widget.rentItem.startDate);
    String dayDifference = (difference.inDays + 1).toString();

    if (dayDifference == '1')
      dayDifference = 'today';
    else
      dayDifference = '$dayDifference days';

    return dayDifference;
  }

  void calculatePrice() {
    DateTime endDate = widget.rentItem.isRent ? userPicked : widget.rentItem.endDate;
    Duration difference = endDate.difference(widget.rentItem.startDate);
    int dayDifference = difference.inDays + 1;

    if (dayDifference > 2) {
      if (widget.rentItem.isPrepaid) {
        // get one day price for prepaid
        total =
            widget.rentItem.itemAmount * widget.rentItem.category.prepaidPrice;
      } else {
        // get one day price for non-prepaid
        total = widget.rentItem.itemAmount * widget.rentItem.category.price;
      }
      // get price for total day
      total = total * (dayDifference - 2);
    } else {
      total = 0;
    }

    // Calculate Total Amount
    setState(() {
      totalAmount = toCurrencyString(
        total.toString(),
        mantissaLength: 0,
        thousandSeparator: ThousandSeparator.Comma,
      );
    });



    // Calculate Remaining Amount
    setState(() {
      total = total - int.parse(widget.rentItem.prepaidAmount);

      remainingAmount = toCurrencyString(
        total.toString(),
        mantissaLength: 0,
        thousandSeparator: ThousandSeparator.Comma,
      );
    });


    // Calculate Prepaid Amount
    setState(() {
      prepaidAmount = toCurrencyString(
        widget.rentItem.prepaidAmount,
        mantissaLength: 0,
        thousandSeparator: ThousandSeparator.Comma,
      );
    });


  }

  String getItemDetails() {
    String itemAmount = widget.rentItem.itemAmount.toString();

    return '${widget.rentItem.category.name} $itemAmount ${widget.rentItem.category.unit}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: DateTime.utc(2021, 1, 1),
      initialDate: today,
      lastDate: DateTime.utc(2100, 12, 31),
    );
    if (picked != null) {
      setState(() {
        endDate = dateTimeToReadableFormat(picked);
      });
      userPicked = picked;
      calculatePrice();
      print(userPicked);
    }
  }

  @override
  void initState() {
    super.initState();
    userPicked = today;
    setState(() {
      itemName =
          '${widget.rentItem.category.name} x ${widget.rentItem.itemAmount} ${widget.rentItem.category.unit}';
      endDate = dateTimeToReadableFormat(today);
      startDate = dateTimeToReadableFormat(widget.rentItem.startDate);
      calculatePrice();
    });
    noteTextEditingController.text = widget.rentItem.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2X),
            child: Column(
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
                ItemDetailsCategoryCard(
                  itemName: itemName,
                  startDate: startDate,
                  endDate: widget.rentItem.isRent? endDate : dateTimeToReadableFormat(widget.rentItem.endDate),
                  isRent: widget.rentItem.isRent,
                  onDateTap: () {
                    _selectDate(context);
                  },
                ),
                SizedBox(height: MARGIN_MEDIUM),
                NoteCard(noteTextEditingController),
                SizedBox(height: MARGIN_MEDIUM),
                PriceCard(totalAmount, prepaidAmount, remainingAmount, total),
                SizedBox(height: MARGIN_XLARGE),
                Row(
                  children: [
                    Visibility(
                      visible: widget.rentItem.isRent ? true : false,
                      child: Expanded(
                        child: DimButtonView(
                          ITEM_DETAILS_FINISH_RENTING_BACKGROUND_COLOR,
                          RENT_DETAILS_FINISH_RENTING_TEXT,
                          textColor: Colors.green,
                          onTap: () {
                            mScaffoldModel.updateRentItemToComplete(
                                widget.rentItem.id, userPicked);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.rentItem.isRent ? true : false,
                      child: SizedBox(width: MARGIN_MEDIUM_2X),
                    ),
                    Expanded(
                      child: DimButtonView(
                        ADD_ITEM_DELETE_BACKGROUND_COLOR,
                        ADD_ITEM_PAGE_DELETE_TEXT,
                        textColor: ADD_ITEM_DELETE_TEXT_COLOR,
                        onTap: () {
                          mScaffoldModel.deleteCompleteItem(widget.rentItem.id);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PriceCard extends StatelessWidget {
  final String prepaidAmount;
  final String totalAmount;
  final String remainingAmount;
  final int total;

  PriceCard(
      this.totalAmount, this.prepaidAmount, this.remainingAmount, this.total);

  @override
  Widget build(BuildContext context) {
    return BasedCardView(
      height: ITEM_DETAILS_PAGE_PRICE_CARD_HEIGHT,
      color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Row(
          children: [
            Text(
              RENT_DETAILS_PAGE_TOTAL_TEXT,
              style: TextStyle(
                color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              totalAmount,
              style: TextStyle(
                color: Colors.black,
                fontSize: TEXT_HEADER_1X,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
            Text(
              prepaidAmount,
              style: TextStyle(
                color: Colors.black,
                fontSize: TEXT_HEADER_1X,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              RENT_DETAILS_PAGE_REMAINING_TEXT,
              style: TextStyle(
                color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                fontSize: TEXT_REGULAR_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Text(
              remainingAmount,
              style: TextStyle(
                color: total >= 0 ? Colors.green : Colors.red,
                fontSize: TEXT_HEADER_2X,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class NoteCard extends StatelessWidget {
  final TextEditingController controller;

  NoteCard(this.controller);

  @override
  Widget build(BuildContext context) {
    return BasedCardView(
      height: ADD_ITEM_PAGE_NOTE_CARD_HEIGHT,
      color: ADD_ITEM_PAGE_NOTE_CARD_COLOR,
      child: TextField(
        controller: controller,
        maxLines: 12,
        minLines: 1,
        readOnly: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: 'There is a note...',
            hintStyle: TextStyle(
              color: ADD_ITEM_PAGE_NOTE_TEXT_COLOR,
              fontSize: TEXT_REGULAR_3X,
            )),
      ),
    );
  }
}

class ItemDetailsCategoryCard extends StatelessWidget {
  final String itemName;
  final String startDate;
  final String endDate;
  final bool isRent;
  final Function() onDateTap;

  ItemDetailsCategoryCard(
      {@required this.itemName,
      @required this.startDate,
      @required this.endDate,
      @required this.isRent,
      @required this.onDateTap});

  @override
  Widget build(BuildContext context) {
    return BasedCardView(
      height: ADD_ITEM_PAGE_CATEGORY_CARD_HEIGHT,
      color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
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
              Text(
                itemName,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: MARGIN_LARGE),
          Row(
            children: [
              Text(
                RENT_DETAILS_PAGE_START_DATE_TEXT,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                startDate,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          SizedBox(height: MARGIN_MEDIUM_2X),
          Row(
            children: [
              Text(
                RENT_DETAILS_PAGE_END_DATE_TEXT,
                style: TextStyle(
                  color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                  fontSize: TEXT_REGULAR_2X,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              isRent
                  ? GestureDetector(
                      onTap: () {
                        onDateTap();
                      },
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                MARGIN_MEDIUM + MARGIN_SMALL)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: MARGIN_MEDIUM_2X,
                              vertical: MARGIN_MEDIUM_2X),
                          child: DropDownContentView(
                              Icons.calendar_today, endDate),
                        ),
                      ),
                    )
                  : Text(
                      endDate,
                      style: TextStyle(
                        color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
                        fontSize: TEXT_REGULAR_2X,
                        fontWeight: FontWeight.w500,
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
