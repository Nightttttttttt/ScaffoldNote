import 'package:flutter/material.dart';
import 'package:scaffold_note/data/model/scaffold_model.dart';
import 'package:scaffold_note/data/model/scaffold_model_impl.dart';
import 'package:scaffold_note/data/vo/rent_item_vo.dart';
import 'package:scaffold_note/resources/colors.dart';
import 'package:scaffold_note/views/rent_item_view.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime today = DateTime.now();
  DateTime firstDay = DateTime.utc(2021, 1, 1);
  DateTime lastDay = DateTime.utc(2025, 12, 1);
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  ScaffoldModel mScaffoldModel = ScaffoldModelImpl();
  List<RentItemVO> rentItemList;
  List<RentItemVO> selectedItemList = [];
  
   Map<DateTime, List<dynamic>> _events= {};
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      rentItemList = mScaffoldModel.getAllRentItemFromDatabase();
      
      rentItemList.forEach((rentItem) {
        DateTime rentDate = rentItem.startDate;
        List<String> idList = [];
        idList.add(rentItem.id);
        List<String> olIdList = [];
        olIdList = _events[DateTime.utc(rentDate.year,rentDate.month,rentDate.day)];

        
        if(olIdList == null){
          _events[DateTime.utc(rentDate.year,rentDate.month,rentDate.day)] = idList;
        }else{
          olIdList.add(rentItem.id);
          _events[DateTime.utc(rentDate.year,rentDate.month,rentDate.day)] = olIdList;
        }


      });
      

    });



  }

  List<dynamic> getSomeEvent(DateTime day){
    
    return _events[day];


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                lastDay: lastDay,
                firstDay: firstDay,
                selectedDayPredicate: (day){
                  return isSameDay(_focusedDay, day);
                },
                onDaySelected: (selectedDay,focusedDay){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay; // update `_focusedDay` here as well
                    //print('selected day - ' + _selectedDay.toString()+'-- focused day - ' + _focusedDay.toString());
                    _selectedEvents = _events[DateTime.utc(selectedDay.year,selectedDay.month,selectedDay.day)];
                      selectedItemList.clear();
                    _selectedEvents?.forEach((itemId) {
                      selectedItemList.add(mScaffoldModel.getRentItemFromDatabase(itemId));
                    });

                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format){
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay){
                  setState(() {
                    _focusedDay = focusedDay;
                  });

                },
                // eventLoader: (day) {
                //   int birthday = day.compareTo(DateTime.utc(2021,7,14));
                //
                //   if(birthday == 0){
                //     return ['birthday'];
                //   }
                //   return [];
                // },

                // eventLoader: (day) {
                //   if (day.weekday == DateTime.monday) {
                //     return ['Cyclic event'];
                //   }
                //
                //   return [];
                // },

                eventLoader: getSomeEvent,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: selectedItemList != null ? selectedItemList.length : 0,
                    itemBuilder: (context, index){
                  return RentItemView(selectedItemList[index]);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
