import 'package:flutter/material.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/resources/dimens.dart';

class CategoryView extends StatelessWidget {
  final CategoryVO category;

  CategoryView(this.category);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2X),
        height: CATEGORY_VIEW_HEIGHT,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        ),
        child: CustomPaint(
          painter: MyPainter(
            lineColor: Colors.black,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: MARGIN_MEDIUM_2X),
              Text(
                category.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: TEXT_REGULAR_2X,

                ),
              ),

            ],


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