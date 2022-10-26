import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final Color? backgroundColor;
  final bool isAllDay;
  final String key;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor,
    required this.isAllDay,
    required this.key,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'backgroundColor': backgroundColor,
      'isAllDay': isAllDay,
      'key': key,
    };
  }

  //create snapshot from firestore data
  factory Event.fromFireBaseSnapShotData(
      QuerySnapshot querySnapshot, Color color) {
    return Event(
      title: querySnapshot.docs.first['title'],
      description: querySnapshot.docs.first['description'],
      from: querySnapshot.docs.first['from'].toDate(),
      to: querySnapshot.docs.first['to'].toDate(),
      backgroundColor: color,
      isAllDay: querySnapshot.docs.first['isAllDay'],
      key: querySnapshot.docs.first.id,
    );
  }

  toJson() {
    return {
      'title': title,
      'description': description,
      'from': from,
      'to': to,
      'backgroundColor': backgroundColor,
      'isAllDay': isAllDay,
      'key': key,
    };
  }
}
