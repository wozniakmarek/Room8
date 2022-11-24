import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:math';

import '../models/challenge.dart';
import '../models/challenges_datasource.dart';
import 'appointment_builder.dart';

//TODO: open challenges screen and set complete to true

class ChallengesWidget extends StatefulWidget {
  @override
  ChallengesWidgetState createState() => ChallengesWidgetState();
}

class ChallengesWidgetState extends State<ChallengesWidget> {
  ChallengesDataSource? challenges = ChallengesDataSource([]);
  final fireStoreReference = FirebaseFirestore.instance;
  bool isInitialLoaded = false;

  @override
  void initState() {
    fireStoreReference.collection('challenges').get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //if result != null then add to list
        if (result != null) {
          final Random random = new Random();
          Challenge app = Challenge.fromFireBaseSnapShotData(querySnapshot);
          setState(() {
            challenges?.appointments?.add(app);
            challenges?.notifyListeners(CalendarDataSourceAction.add, [app]);
          });
        }
      });
      setState(() {
        isInitialLoaded = true;
      });
      fireStoreReference.collection('challenges').snapshots().listen((event) {
        for (var element in event.docChanges) {
          if (element.type == DocumentChangeType.added &&
              querySnapshot.docs != null) {
            List<DateTime> exceptionDates = [];
            if (querySnapshot.docs.isNotEmpty) {
              if (querySnapshot.docs[0]['exceptionDates'] != null) {
                for (var date in querySnapshot.docs[0]['exceptionDates']) {
                  exceptionDates.add(date.toDate());
                }
              }
            }

            final challenge = Challenge(
              title: element.doc.data()!['title'],
              isAllDay: element.doc.data()!['isAllDay'],
              from: element.doc.data()!['isAllDay']
                  ? element.doc.data()!['from'].toDate()
                  : element.doc.data()!['from'].toDate(),
              to: element.doc.data()!['isAllDay']
                  ? element.doc.data()!['to'].toDate()
                  : element.doc.data()!['to'].toDate(),
              description: element.doc.data()!['description'],
              id: //element.doc.data()!['id'],
                  element.doc.id,
              userId: element.doc.data()!['userId'],
              userName: element.doc.data()!['userName'],
              recurrenceId: element.doc.data()!['recurrenceId'],
              recurrenceRule: element.doc.data()!['recurrenceRule'],
              exceptionDates: exceptionDates,
              points: element.doc.data()!['points'],
              completed: element.doc.data()!['completed'],
              isRecurrence: element.doc.data()!['isRecurrence'],
              category: element.doc.data()!['category'],
              color: element.doc.data()!['color'],
            );

            challenges?.appointments?.add(challenge);
            challenges
                ?.notifyListeners(CalendarDataSourceAction.add, [challenge]);
          }
          getDataFromFireStore().then((value) {
            SchedulerBinding.instance.addPostFrameCallback((_) {});
          });
        }
      });
    });
  }

  Future<void> getDataFromFireStore() async {
    var snapShotValue = await fireStoreReference.collection('challenges').get();
    //check if in snapShotValue in every docs ['exceptionDates'] != null if true  exceptionDates.add(date.toDate());
    List<DateTime> exceptionDates = [];
    for (var element in snapShotValue.docs) {
      if (element.data()['exceptionDates'] != null) {
        for (var date in element.data()['exceptionDates']) {
          exceptionDates.add(date.toDate());
        }
      }
    }
    List<Challenge> challengesList = snapShotValue.docs
        .map(((e) => Challenge(
              title: e.data()['title'],
              isAllDay: e.data()['isAllDay'],
              from: e.data()['isAllDay']
                  ? e.data()['from'].toDate()
                  : e.data()['from'].toDate(),
              to: e.data()['isAllDay']
                  ? e.data()['to'].toDate()
                  : e.data()['to'].toDate(),
              description: e.data()['description'],
              id: e.id,
              userId: e.data()['userId'],
              userName: e.data()['userName'],
              recurrenceId: e.data()['recurrenceId'],
              recurrenceRule: e.data()['recurrenceRule'],
              exceptionDates: exceptionDates,
              points: e.data()['points'],
              completed: e.data()['completed'],
              isRecurrence: e.data()['isRecurrence'],
              category: e.data()['category'],
              color: e.data()['color'],
            )))
        .toList();
//add mounted
    if (mounted) {
      setState(() {
        challenges = ChallengesDataSource(challengesList);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SfCalendar(
        firstDayOfWeek: 1,
        dataSource: challenges,
        view: CalendarView.schedule,
        scheduleViewSettings: ScheduleViewSettings(
          monthHeaderSettings: MonthHeaderSettings(
            height: 60,
            textAlign: TextAlign.center,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          appointmentItemHeight: 60,
        ),
        appointmentBuilder: appointmentBuilder,
      ),
    );
  }
}

/*

do initstate 

getDataFromFireStore().then((value) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    });
*/
