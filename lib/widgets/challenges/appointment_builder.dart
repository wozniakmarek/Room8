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
      Container(
        decoration: BoxDecoration(
          color: Color(int.parse(appointment.color, radix: 16)),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            //show the icon on left side of the appointment, title, userName and description in center and points with checkbox to update points on right
            Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(int.parse(appointment.color, radix: 16)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                IconData(appointment.category, fontFamily: 'MaterialIcons'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    appointment.userName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  //add description text but if its too long, cut it off and add ...
                  Text(
                    appointment.description,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    // maxLines: 1,
                    // softWrap: false,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
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
                  //ask if shure to update
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Update Challenge"),
                          content: Text("Are you sure you want to update?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            TextButton(
                                onPressed: () {
                                  //update the challenge in the database
                                  FirebaseFirestore.instance
                                      .collection('challenges')
                                      .doc(appointment.id)
                                      .update({
                                    'completed': value,
                                  });
                                  if (value == true) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(appointment.userId)
                                        .update({
                                      'points': FieldValue.increment(
                                          appointment.points)
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(appointment.userId)
                                        .update({
                                      'points': FieldValue.increment(
                                          -appointment.points)
                                    });
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text("Update")),
                          ],
                        );
                      });
                  //if completed is true add points to user points if false remove points
                  //from user points
                }),
          ],
        ),
      ),
    ],
  );
}
