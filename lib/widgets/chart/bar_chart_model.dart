import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BarChartModel {
  String userName;
  int points;
  final charts.Color color;

  BarChartModel(
      {required this.userName, required this.points, required this.color});
}
