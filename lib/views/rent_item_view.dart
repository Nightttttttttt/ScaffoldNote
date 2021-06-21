import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/pages/rent_item_details.dart';
import 'package:scaffold_note/resources/dimens.dart';

class RentItemView extends StatelessWidget {

  final RentItemVO rentItem;
  // final engNumber = ['0','1','2','3','4','5','6','7','8','9'];
  // final mmNumber = ['၀','၁','၂','၃','၄','၅','၆','၇','၈','၉'];


  RentItemView(this.rentItem);



  String getDayDifference(){
    DateTime endDay = rentItem.isRent ? DateTime.now() : rentItem.endDate;
    Duration difference = endDay.difference(rentItem.startDate);
    String dayDifference = (difference.inDays + 1).toString();

    if(dayDifference == '1') dayDifference = 'today';
    else dayDifference = '$dayDifference days';

    return dayDifference;
  }

  String getPrice(){
    DateTime endDay = rentItem.isRent ? DateTime.now() : rentItem.endDate;
    Duration difference = endDay.difference(rentItem.startDate);
    int dayDifference = difference.inDays + 1;
    int total;

    if(dayDifference > 2){
      if(rentItem.isPrepaid){
         // get one day price for prepaid
         total = rentItem.itemAmount * rentItem.category.prepaidPrice;
      }else{
         // get one day price for non-prepaid
         total = rentItem.itemAmount * rentItem.category.price;
      }
      // get price for total day
      total = total * (dayDifference - 2);
    }else{
      total = 0;
    }

    String totalFormatText = toCurrencyString(
        total.toString(),
        thousandSeparator: ThousandSeparator.Comma,
        mantissaLength: 0,
    );



    return totalFormatText;

  }

  String getItemDetails(){
    String itemAmount = rentItem.itemAmount.toString();

    return '${rentItem.category.name} $itemAmount ${rentItem.category.unit}';


  }

  Color getLineColor(){
    return rentItem.isRent ? Colors.blue : Colors.green;
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2X),
        height: RENT_ITEM_VIEW_HEIGHT,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X),
        ),
        child: CustomPaint(
          painter: MyPainter(lineColor: getLineColor()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2X, vertical: MARGIN_MEDIUM),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(rentItem.note == null ? 'Empty' : rentItem.note),
                    Spacer(),
                    Icon(
                      Icons.history,
                      size: MARGIN_MEDIUM_2X,
                      color: Colors.grey,
                    ),
                    SizedBox(width: MARGIN_MEDIUM),
                    Text(
                        getDayDifference(),
                      style: TextStyle(
                        color: Colors.grey,
                      ),

                    )
                  ],
                ),
                Row(
                  children: [
                    Text(getItemDetails()),
                    Spacer(),
                    SizedBox(width: MARGIN_MEDIUM),
                    Text(
                      '+${getPrice()}',
                      style: TextStyle(
                        color: Colors.green,
                      ),

                    )
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

class MyPainter extends CustomPainter{
  final Color lineColor;

  MyPainter({@required this.lineColor});
  
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    /// Dash Paint
    Paint linePaint = Paint();
    linePaint.strokeWidth = 3;
    linePaint.color = lineColor;

    final double X = 1.5;
    final double startY = height * 0.4;
    final double endY = height * 0.6;

    canvas.drawLine(Offset(X, startY), Offset(X,endY), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this == oldDelegate;
  }

}