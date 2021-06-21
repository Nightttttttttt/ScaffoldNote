import 'package:flutter/material.dart';
import 'package:scaffold_note/resources/dimens.dart';

class BasedCardView extends StatelessWidget {
  final Widget child;
  final Color color;
  final double height;

  BasedCardView({@required this.height, @required this.color, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2X, vertical: MARGIN_MEDIUM),
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2X),
      ),
      child: child,
    );
  }
}
