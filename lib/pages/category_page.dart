import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/model/scaffold_model_impl.dart';
import 'package:scaffold_note/data/vo/category_vo.dart';
import 'package:scaffold_note/data/vo/validator.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/resources/dimens.dart';
import 'package:scaffold_note/resources/strings.dart';
import 'package:scaffold_note/views/category_view.dart';
import 'package:scaffold_note/views/close_button_view.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ScaffoldModel mScaffoldModel = ScaffoldModelImpl();
  List<CategoryVO> categoryList;
  String categoryName = '';
  String categoryUnit = '';
  int categoryPrice = 0;
  int categoryPrepaidPrice = 0;
  int categoryMinimum = 0;
  int categoryMaximum = 100;
  @override
  void initState() {
    super.initState();
    categoryList = mScaffoldModel.getAllCategoryFromDatabase();
  }

  Validator checkValidation(){
    String msg = '';
    bool pass = true;
    if(categoryName.length > 25){
      pass = false;
      msg += "Name too long.\n";
    }
    if(categoryUnit.length > 10){
      pass = false;
      msg += "Unit name too long.\n";
    }

    if(categoryUnit == '' && categoryName == ''){
      pass = false;
      msg += "Name and unit can'\t be empty.\n";
    }


    if(categoryPrice == 0 && categoryPrepaidPrice == 0 ){
      pass = false;
      msg += "price and prepaid price can\'t be zero.\n";
    }

    if(categoryPrepaidPrice > categoryPrice){
      pass = false;
      msg += "Invalid! price must greater than prepaid.\n";
    }

    if(categoryMinimum > categoryMaximum){
      pass = false;
      msg += "Invalid! maximum must greater than minimum.\n";
    }
    msg += '**********';

    Validator validator = Validator(pass, msg);

    return validator;
  }

  void addCategoryToDB(){
    Validator validator = checkValidation();

    if(validator.pass){
      CategoryVO categoryVO = CategoryVO(categoryName, categoryPrice, categoryPrepaidPrice, categoryUnit, categoryMinimum,categoryMaximum,getUniqueId());
      mScaffoldModel.addCategoryToDatabase(categoryVO);
      setState(() {
        categoryList = mScaffoldModel.getAllCategoryFromDatabase();
      });
      Navigator.pop(context);
    }else{
      Fluttertoast.showToast(
          msg: validator.condition,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }


  }

  String getUniqueId(){
    DateTime now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }
  
  void showCategoryDetailsDialog(CategoryVO categoryVO) async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
       backgroundColor: Colors.white,
       title: Text(categoryVO.name),
       content: SingleChildScrollView(
         child: Column(
           children: [
             TextRow(CATEGORY_DIALOG_UNIT_TEXT,categoryVO.unit),
             SizedBox(height: MARGIN_MEDIUM_2X),
             TextRow(CATEGORY_DIALOG_PRICE_TEXT,categoryVO.price.toString()),
             SizedBox(height: MARGIN_MEDIUM_2X),
             TextRow(CATEGORY_DIALOG_DISCOUNT_TEXT,categoryVO.prepaidPrice.toString()),
             SizedBox(height: MARGIN_MEDIUM_2X),
             TextRow(CATEGORY_DIALOG_MINIMUM_TEXT,categoryVO.minAmount.toString()),
             SizedBox(height: MARGIN_MEDIUM_2X),
             TextRow(CATEGORY_DIALOG_MAXIMUM_TEXT,categoryVO.maxAmount.toString()),
             SizedBox(height: MARGIN_MEDIUM_2X),
           ],
         ),
       ), 
      );
    });
  }

  void showAddDialog() async{
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(CATEGORY_DIALOG_NEW_CATEGORY_TEXT),
        content: Container(
          padding: EdgeInsets.all(MARGIN_MEDIUM),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CATEGORY_DIALOG_CATEGORY_NAME_TEXT),
                SizedBox(height: MARGIN_MEDIUM),
                RoundedTextField(CATEGORY_DIALOG_NAME_HINT,false,onChanged:(value){
                  categoryName = value;
                }),
                SizedBox(height: MARGIN_MEDIUM_3X),

                Text(CATEGORY_DIALOG_UNIT_TEXT),
                SizedBox(height: MARGIN_MEDIUM),
                RoundedTextField(CATEGORY_DIALOG_UNIT_HINT,false,onChanged:(value){
                  categoryUnit = value;
                }),
                SizedBox(height: MARGIN_MEDIUM_3X),

                Text(CATEGORY_DIALOG_PRICE_TEXT),
                SizedBox(height: MARGIN_MEDIUM),
                RoundedTextField(CATEGORY_DIALOG_PRICE_HINT,true,onChanged:(value){
                  categoryPrice = int.parse(value);
                }),
                SizedBox(height: MARGIN_MEDIUM_3X),


                Text(CATEGORY_DIALOG_DISCOUNT_TEXT),
                SizedBox(height: MARGIN_MEDIUM),
                RoundedTextField(CATEGORY_DIALOG_DISCOUNT_HINT,true,onChanged:(value){
                  categoryPrepaidPrice = int.parse(value);
                }),
                SizedBox(height: MARGIN_MEDIUM_3X),

                Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CATEGORY_DIALOG_MINIMUM_TEXT),
                          SizedBox(height: MARGIN_MEDIUM),
                          RoundedTextField(CATEGORY_DIALOG_MINIMUM_HINT,true,onChanged:(value){
                            categoryMinimum = int.parse(value);
                          }),
                        ],
                      ),
                    ),

                    SizedBox(width: MARGIN_MEDIUM),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(CATEGORY_DIALOG_MAXIMUM_TEXT),
                          SizedBox(height: MARGIN_MEDIUM),
                          RoundedTextField(CATEGORY_DIALOG_MAXIMUM_HINT,true,onChanged:(value){
                            categoryMaximum = int.parse(value);
                          }),
                        ],
                      ),
                    )
                  ],
                )

              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel')),
          TextButton(onPressed: (){
            addCategoryToDB();
          }, child: Text('Save')),
          SizedBox(width: MARGIN_MEDIUM)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
      body: SafeArea(
        child: Column(
          children: [
            CategoryHeaderSectionView(
              onCloseTap: (){
                Navigator.pop(context);
              },
              onAddTap: () async{
                 showAddDialog();



              },
            ),
            SizedBox(height: MARGIN_MEDIUM),
            Expanded(
              child: ListView.builder(
                  itemCount: categoryList.length != 0 ? categoryList.length : 0,
                  itemBuilder: (context,index){
                return GestureDetector(
                    onLongPress: (){
                      mScaffoldModel.deleteCategory(categoryList[index].id);
                      setState(() {
                        categoryList = mScaffoldModel.getAllCategoryFromDatabase();
                      });
                    },
                    onTap: (){
                      showCategoryDetailsDialog(categoryList[index]);
                    },
                    child: CategoryView(categoryList[index]));
              }),
            )
          ],
        ),
        

      ),
    );
  }
}

class TextRow extends StatelessWidget {
  final String name;
  final String detail;

  TextRow(this.name,this.detail);

  @override
  Widget build(BuildContext context) {
    return Row(
      children : [
        Text(name),
        SizedBox(width: MARGIN_MEDIUM_2X),
        Text(detail)
      ]
    );
  }
}

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final bool isNumber;
  final Function(String) onChanged;

  RoundedTextField(this.hintText,this.isNumber,{@required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MARGIN_XXLARGE,
      padding: EdgeInsets.all(MARGIN_MEDIUM),
      decoration: BoxDecoration(
        color: ADD_ITEM_PAGE_CATEGORY_CARD_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
      ),
      child: TextField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: TEXT_REGULAR_2X,
            ),
        ),
        onChanged: (value){
          onChanged(value);
        },
      ),
    );
  }
}

class CategoryHeaderSectionView extends StatelessWidget {
  final Function onCloseTap;
  final Function onAddTap;

  CategoryHeaderSectionView({@required this.onCloseTap,@required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MARGIN_MEDIUM_2X),
          Row(
            children: [
              Spacer(),
              CloseButtonView(
                  (){
                    onCloseTap();
                  }
              ),
            ],
          ),
          SizedBox(height: MARGIN_MEDIUM_2X),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_3X),
            child: Row(
              children: [
                Text(
                  CATEGORY_PAGE_CATEGORY_TEXT,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: TEXT_HEADER_2X,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                NewCategoryButton(
                  onTap: (){
                    onAddTap();
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewCategoryButton extends StatelessWidget {
  final Function onTap;
  
  NewCategoryButton({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        width: 100,
        height: MARGIN_XLARGE,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MARGIN_SMALL),
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
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(width: MARGIN_MEDIUM),
              Text(
                'New',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(width: MARGIN_MEDIUM_2X),
            ],
          ),
        ),
      ),
    );
  }
}
