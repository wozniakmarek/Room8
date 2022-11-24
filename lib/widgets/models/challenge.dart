import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Challenge {
  Challenge(
      {required this.from,
      required this.to,
      required this.id,
      this.recurrenceId,
      this.title = '',
      required this.description,
      this.isAllDay = true,
      this.exceptionDates,
      this.recurrenceRule,
      required this.points,
      this.userId,
      this.userName = '',
      this.completed = false,
      this.isRecurrence = false,
      this.category = 0,
      required this.color});

  DateTime from;
  DateTime to;
  String id;
  Object? recurrenceId;
  String title;
  String description;
  bool isAllDay;
  String? fromZone;
  String? toZone;
  String? recurrenceRule;
  List<DateTime>? exceptionDates;
  int points;
  String? userId;
  String userName;
  bool isRecurrence = false;
  bool completed = false;
  int category;
  String color;

  //toMap
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isAllDay': isAllDay,
      'from': isAllDay ? from : from,
      'to': isAllDay ? to : to,
      'id': id,
      'recurrenceId': recurrenceId,
      'fromZone': fromZone,
      'toZone': toZone,
      'recurrenceRule': recurrenceRule,
      'exceptionDates': exceptionDates,
      'points': points,
      'userId': userId,
      'userName': userName,
      'isRecurrence': isRecurrence,
      'completed': completed,
      'category': category,
      'color': color,
    };
  }

  factory Challenge.fromFireBaseSnapShotData(QuerySnapshot querySnapshot) {
    //create List<dateTime> from exceptionDates
    List<DateTime> exceptionDates = [];
    if (querySnapshot.docs[0]['exceptionDates'] != null) {
      for (var date in querySnapshot.docs[0]['exceptionDates']) {
        exceptionDates.add(date.toDate());
      }
    }

    return Challenge(
      title: querySnapshot.docs.first['title'],
      description: querySnapshot.docs.first['description'],
      isAllDay: querySnapshot.docs.first['isAllDay'],
      from: querySnapshot.docs.first['from'].toDate(),
      to: querySnapshot.docs.first['to'].toDate(),
      id: querySnapshot.docs.first.id,
      recurrenceId: querySnapshot.docs.first['recurrenceId'],
      recurrenceRule: querySnapshot.docs.first['recurrenceRule'],
      exceptionDates: exceptionDates,
      points: querySnapshot.docs.first['points'],
      userId: querySnapshot.docs.first['userId'],
      userName: querySnapshot.docs.first['userName'],
      isRecurrence: querySnapshot.docs.first['isRecurrence'],
      completed: querySnapshot.docs.first['completed'],
      category: querySnapshot.docs.first['category'],
      color: querySnapshot.docs.first['color'],
    );
  }
}
