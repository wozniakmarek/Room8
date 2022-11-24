import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:room8/widgets/chart/bar_chart_model.dart';

class BarChartGraph extends StatefulWidget {
  final List<BarChartModel> data;

  const BarChartGraph({Key? key, required this.data}) : super(key: key);

  @override
  _BarChartGraphState createState() => _BarChartGraphState();
}

class _BarChartGraphState extends State<BarChartGraph> {
  late List<BarChartModel> _barChartList;

  @override
  void initState() {
    super.initState();
    _barChartList = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Points",
          data: widget.data,
          domainFn: (BarChartModel series, _) => series.userName,
          measureFn: (BarChartModel series, _) => series.points,
          colorFn: (BarChartModel series, _) => series.color),
    ];

    return _buildGraf(series);
  }

  Widget _buildGraf(series) {
    return _barChartList != null
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
              height: 5,
            ),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: MediaQuery.of(context).size.height / 1.15,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                        child: charts.BarChart(
                      series,
                      animate: true,
                    )),
                  ],
                ),
              );
            },
          )
        : SizedBox();
  }
}
