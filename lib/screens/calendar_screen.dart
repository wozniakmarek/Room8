import 'package:flutter/material.dart';
import 'package:room8/widgets/calendar/event_editing_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../widgets/calendar/calendar_widget.dart';
import '../widgets/pickers/expandableFab.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventEditingPage(context, null)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
