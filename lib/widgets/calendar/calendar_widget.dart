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
  List<Color> _colorCollection = <Color>[];
  EventDataSource? events;
  final List<String> options = <String>['Add', 'Delete', 'Update'];
  final fireStoreReference = FirebaseFirestore.instance;
  bool isInitialLoaded = false;

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _initializeEventColor();
    //get data from firestore and add to calendar
    fireStoreReference.collection('events').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        final Random random = new Random();
        Event app = Event.fromFireBaseSnapShotData(
            querySnapshot, _colorCollection[random.nextInt(9)]);
        setState(() {
          events?.appointments?.add(app);
          events?.notifyListeners(CalendarDataSourceAction.add, [app]);
        });
      });
      setState(() {
        isInitialLoaded = true;
      });
      //add listener to firestore collection
      fireStoreReference.collection('events').snapshots().listen((event) {
        event.docChanges.forEach((element) {
          if (element.type == DocumentChangeType.added) {
            final event = Event(
              title: element.doc.data()!['title'],
              from: element.doc.data()!['from'].toDate(),
              to: element.doc.data()!['to'].toDate(),
              isAllDay: element.doc.data()!['isAllDay'],
              backgroundColor: _colorCollection[Random().nextInt(9)],
              description: element.doc.data()!['description'],
              key: element.doc.id,
            );
            events?.appointments?.add(event);
            setState(() {});
          } else if (element.type == DocumentChangeType.modified) {
            final event = Event(
              title: element.doc.data()!['title'],
              from: element.doc.data()!['from'].toDate(),
              to: element.doc.data()!['to'].toDate(),
              isAllDay: element.doc.data()!['isAllDay'],
              backgroundColor: _colorCollection[Random().nextInt(9)],
              description: element.doc.data()!['description'],
              key: element.doc.id,
            );
            events?.appointments
                ?.removeWhere((element) => element.key == event.key);
            events?.appointments?.add(event);
            setState(() {});
          } else if (element.type == DocumentChangeType.removed) {
            events?.appointments
                ?.removeWhere((element) => element.key == element.key);
            setState(() {});
          }
          getDataFromFireStore().then((value) {
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              setState(() {});
            });
          });
        });
      });
    });
    super.initState();
  }

  //after saveForm is called, this method is called to update the calendar
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
            backgroundColor: _colorCollection[random.nextInt(9)],
            isAllDay: false,
            description: e.data()['description'],
            key: e.id))
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
      //set Monday as the first day of the week
      firstDayOfWeek: 1,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      onLongPress: (details) {
        showModalBottomSheet(
            context: context,
            builder: ((context) => _buildBottomSheet(events!)));
      },
    );
  }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  _buildBottomSheet(EventDataSource events) {
    //return SfCalendar view with the required properties to create the calendar view with timelineDay view.
    return Container(
      height: 300,
      child: SfCalendar(
          view: CalendarView.timelineDay,
          dataSource: events,
          timeSlotViewSettings: TimeSlotViewSettings(
            timeInterval: const Duration(minutes: 60),
            timeIntervalHeight: 60,
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
                        )));
          }),
    );
  }
}

class DayCalendar extends StatefulWidget {
  const DayCalendar(
    this.events,
    this.date,
  );

  final DateTime? date;
  final EventDataSource? events;

  @override
  State<DayCalendar> createState() => _DayCalendarState();
}

class _DayCalendarState extends State<DayCalendar> {
  @override
  Widget build(BuildContext context) {
    //filter events for selected date
    List events = widget.events!.appointments!
        .where((element) =>
            element.from!.day == widget.date!.day &&
            element.from!.month == widget.date!.month &&
            element.from!.year == widget.date!.year)
        .toList();
    return SfCalendar(
      dataSource: widget.events,
      view: CalendarView.timelineDay,
      monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    );
  }
}
