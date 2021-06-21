import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold_note/resources/dimens.dart';
import 'package:scaffold_note/views/circulator_tab_indicator.dart';

class StickyDelegate extends SliverPersistentHeaderDelegate {
  final List<String> headerList;
  final Function(int) onTap;

  StickyDelegate(this.headerList,this.onTap);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(MARGIN_LARGE),
          bottomLeft: Radius.circular(MARGIN_LARGE),
        ),
      ),
      child: DefaultTabController(
        length: headerList.length,
        child: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          indicator: CircularTabIndicator(Colors.blue, MARGIN_SMALL - 1),
          tabs: headerList.map((header) => Tab(text : header)).toList() ,
          onTap: (index){
            onTap(index);
          },
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80.0;

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return this == oldDelegate;
  }
}
