import 'package:flutter/material.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';

class CloseButtonView extends StatelessWidget {

  final Function onTap;

  CloseButtonView(this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MARGIN_MEDIUM_2X),
      child: GestureDetector(
        onTap: (){
          onTap();
        },
        child: Icon(
          Icons.close,
          color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
        ),
      ),
    );
  }
}
