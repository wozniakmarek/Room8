import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:room8/widgets/models/challenge.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget appointmentBuilder(BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails) {
  final Challenge appointment = calendarAppointmentDetails.appointments.first;
  return Column(
    children: [
      //on left show category icon and on right points
      //in the middle show title and description
      Container(
        decoration: BoxDecoration(
          color: Color(int.parse(appointment.color, radix: 16)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(int.parse(appointment.color, radix: 16)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(IconData(appointment.category,
                    fontFamily: 'MaterialIcons'))),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.title,
                    style: TextStyle(
                      //letters crossed out if completed
                      //decoration: TextDecoration.lineThrough

                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(appointment.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis),
                  Text(appointment.userName)
                ],
              ),
            ),
            Spacer(),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse(appointment.color, radix: 16)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  appointment.points.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //add checkbox if completed
            Checkbox(
                value: appointment.completed,
                onChanged: (bool? value) {
                  //update completed value in firestore and in calendar appointment
                  //and update calendar

                  FirebaseFirestore.instance
                      .collection('challenges')
                      .doc(appointment.id)
                      .update({'completed': value});

                  //if completed is true add points to user points if false remove points
                  //from user points
                  if (value == true) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(appointment.userId)
                        .update({
                      'points': FieldValue.increment(appointment.points)
                    });
                  } else {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(appointment.userId)
                        .update({
                      'points': FieldValue.increment(-appointment.points)
                    });
                  }
                }),
          ],
        ),
      ),
    ],
  );
}
