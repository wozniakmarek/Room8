import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  late String backgroundColor;
  final bool isAllDay;
  late String? id;
  late String? userId;
  late String userName;

  Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    required this.backgroundColor,
    required this.isAllDay,
    this.id,
    this.userId,
    this.userName = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isAllDay': isAllDay,
      'from': isAllDay ? Timestamp.fromDate(from) : from,
      'to': isAllDay ? Timestamp.fromDate(to) : to,
      'backgroundColor': backgroundColor,
      'id': id,
      'userId': userId,
      'userName': userName,
    };
  }

  factory Event.fromFireBaseSnapShotData(QuerySnapshot querySnapshot) {
    return Event(
      title: querySnapshot.docs.first['title'],
      description: querySnapshot.docs.first['description'],
      from: querySnapshot.docs.first['from'].toDate(),
      to: querySnapshot.docs.first['to'].toDate(),
      backgroundColor: querySnapshot.docs.first['backgroundColor'],
      isAllDay: querySnapshot.docs.first['isAllDay'],
      id: querySnapshot.docs.first.id,
      userId: querySnapshot.docs.first['userId'],
      userName: querySnapshot.docs.first['userName'],
    );
  }
}
