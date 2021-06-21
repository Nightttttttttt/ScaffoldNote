import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scaffold_note/pages/category_page.dart';
import 'package:scaffold_note/pages/home_page.dart';
import 'package:scaffold_note/persistence/hive_constants.dart';

import 'data/vo/category_vo.dart';
import 'data/vo/rent_item_vo.dart';


void main() async{
   await Hive.initFlutter();
   Hive.registerAdapter(CategoryVOAdapter());
   Hive.registerAdapter(RentItemVOAdapter());

   await Hive.openBox<CategoryVO>(BOX_NAME_CATEGORY_VO);
   await Hive.openBox<RentItemVO>(BOX_NAME_RENT_ITEM_VO);

   SystemChrome.setPreferredOrientations(
       [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
       .then((_) => runApp(MyApp()),
   );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}


