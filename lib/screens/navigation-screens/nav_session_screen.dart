// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_final_fields, unused_element, unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  DateTime? _currentDate = DateTime.now();
  EventList<Event> _markedDateMap = EventList<Event>(events: {});

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/main'),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              this.setState(() => _currentDate = date);
            },
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,

//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
            customDayBuilder: (
              /// you can provide your own build function to make custom day containers
              bool isSelectable,
              int index,
              bool isSelectedDay,
              bool isToday,
              bool isPrevMonthDay,
              TextStyle textStyle,
              bool isNextMonthDay,
              bool isThisMonthDay,
              DateTime day,
            ) {
              /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
              /// This way you can build custom containers for specific days only, leaving rest as default.

              // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
              if (day.day == 15) {
                return Center(
                  child: Icon(Icons.local_airport),
                );
              } else {
                return null;
              }
            },
            weekFormat: false,
            markedDatesMap: _markedDateMap,
            height: 420.0,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: true,

            /// null for not rendering any border, true for circular border, false for rectangular border
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: _presentDatePicker,
      //     backgroundColor: Color(0xFFFE6903),
      //     child: Icon(Icons.add)),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
