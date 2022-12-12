import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/event_datasource.dart';
import '../models/event.dart';
import 'dart:math';

import 'event_viewing_page.dart';

class CalendarWidget extends StatefulWidget {
  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  EventDataSource? events;
  final List<String> options = <String>['Add', 'Delete', 'Update'];
  final fireStoreReference = FirebaseFirestore.instance;
  bool isInitialLoaded = false;

  @override
  void initState() {
    fireStoreReference.collection('events').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        final Random random = new Random();
        Event app = Event.fromFireBaseSnapShotData(querySnapshot);
        setState(() {
          events?.appointments?.add(app);
          events?.notifyListeners(CalendarDataSourceAction.add, [app]);
        });
      });
      setState(() {
        isInitialLoaded = true;
      });
      fireStoreReference.collection('events').snapshots().listen((event) {
        for (var element in event.docChanges) {
          if (element.type == DocumentChangeType.added) {
            final event = Event(
              title: element.doc.data()!['title'],
              isAllDay: element.doc.data()!['isAllDay'],
              from: element.doc.data()!['isAllDay']
                  ? element.doc.data()!['from'].toDate()
                  : element.doc.data()!['from'].toDate(),
              to: element.doc.data()!['isAllDay']
                  ? element.doc.data()!['to'].toDate()
                  : element.doc.data()!['to'].toDate(),
              backgroundColor: element.doc.data()!['backgroundColor'],
              description: element.doc.data()!['description'],
              id: element.doc.data()!['id'],
              userId: element.doc.data()!['userId'],
              userName: element.doc.data()!['userName'],
            );
            events?.appointments?.add(event);
            events?.notifyListeners(CalendarDataSourceAction.add, [event]);
          }
          getDataFromFireStore().then((value) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          });
        }
      });
    });
  }

  void updateCalendar(Event event) {
    setState(() {
      events!.appointments!.add(event);
      events!.notifyListeners(CalendarDataSourceAction.add, [event]);
    });
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await fireStoreReference.collection('events').get();

    final Random random = new Random();
    List<Event> list = snapShotsValue.docs
        .map((e) => Event(
              title: e.data()['title'],
              from: e.data()['from'].toDate(),
              to: e.data()['to'].toDate(),
              backgroundColor: e.data()['backgroundColor'],
              isAllDay: e.data()['isAllDay'],
              description: e.data()['description'],
              id: e.data()['id'],
              userId: e.data()['userId'],
              userName: e.data()['userName'],
            ))
        .toList();
    setState(() {
      events = EventDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: events,
      firstDayOfWeek: 1,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      onLongPress: (details) {
        showModalBottomSheet(
            context: context,
            builder: ((context) => _buildBottomSheet(events!, details.date)));
      },
    );
  }

  _buildBottomSheet(EventDataSource events, DateTime? date) {
    return Container(
      child: SfCalendar(
        view: CalendarView.timelineWeek,
        firstDayOfWeek: 1,
        dataSource: events,
        timeSlotViewSettings: TimeSlotViewSettings(
          timeInterval: const Duration(hours: 1),
          timeIntervalHeight: 45,
          minimumAppointmentDuration: const Duration(minutes: 60),
        ),
        headerHeight: 0,
        todayHighlightColor: Colors.purple,
        selectionDecoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.3),
        ),
        onTap: (details) {
          if (details.appointments == null) return;
          final Event event = details.appointments![0];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventViewingPage(
                event: event,
              ),
            ),
          );
        },
      ),
    );
  }
}
