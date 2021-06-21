import 'package:flutter/material.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';



class CardDropDownView extends StatelessWidget {
  final List<String> itemList;
  final IconData iconData;
  final String chosenItem;
  final Function(String value) onChanged;
  final Function onTap;


  CardDropDownView({@required this.itemList, @required this.iconData,@required this.chosenItem,@required this.onChanged,this.onTap });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM + MARGIN_SMALL)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM + MARGIN_SMALL),
        child: DropdownButton(
          items: itemList.map(
                (item) => DropdownMenuItem(child: DropDownContentView(iconData,item), value: item,),
          ).toList(),
          elevation: 0,
          underline: SizedBox(),
          value: chosenItem,

          onChanged: (value){
            onChanged(value);
          },
          onTap: (){
            onTap();
          },
        ),
      ),
    );
  }
}


class DropDownContentView extends StatelessWidget {
  final IconData icon;
  final String text;

  DropDownContentView(this.icon,this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: MARGIN_MEDIUM_2X,
          color: Colors.blue,
        ),
        SizedBox(width: MARGIN_MEDIUM_2X),
        Text(
          text,
          style: TextStyle(
            color: ADD_ITEM_PAGE_CATEGORY_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
            fontWeight: FontWeight.w500,
          ),),
      ],
    );
  }
}
