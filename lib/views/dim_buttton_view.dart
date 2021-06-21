import 'package:flutter/material.dart';
import 'package:scaffold_note/resources/dimens.dart';

class DimButtonView extends StatelessWidget {
  final Color backColor;
  final String text;
  final Color textColor;
  final Function onTap;

  DimButtonView(this.backColor, this.text, {this.textColor,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: DIM_BUTTON_HEIGHT,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor == null ? Colors.black : textColor,
              fontSize: TEXT_REGULAR_2X,
            ),
          ),
        ),
      ),
    );
  }
}
