import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart';

import '../widgets/chart/bar_chart_graph.dart';
import '../widgets/chart/bar_chart_model.dart';
import 'package:color_converter/color_converter.dart';

class ChartScreen extends StatefulWidget {
  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  //from firestore get all users and their points and add to list

  List<BarChartModel> data = [];

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result != null) {
          data.add(BarChartModel(
              userName: result['userName'],
              points: result['points'],
              //Theme.of(context).primaryColor is color
              color: charts.ColorUtil.fromDartColor(
                  Theme.of(context).primaryColor)));
        }
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart'),
      ),
      body: Container(
          child: ListView(
        shrinkWrap: true,
        children: [
          BarChartGraph(data: data),
        ],
      )),
    );
  }
}
