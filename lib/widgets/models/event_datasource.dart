import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../models/event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    String color = appointments![index].backgroundColor;
    int colorInt = int.parse(color, radix: 16);
    Color colorValue = Color(colorInt);
    return colorValue;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getNotes(int index) {
    return appointments![index].description;
  }
}
