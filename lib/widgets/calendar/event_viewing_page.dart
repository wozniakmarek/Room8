import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// ignore: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../pickers/expandableFab.dart';
import 'event_editing_page.dart';
import 'event_provider.dart';

class EventViewingPage extends StatelessWidget {
  late final Event event;
  final fireStoreReference = FirebaseFirestore.instance;

  EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  Widget buildDate(BuildContext context, DateTime _from, DateTime _to) {
    final bool isSameDay = event.from.day == event.to.day;
    final bool isSameMonth = event.from.month == event.to.month;
    final bool isSameYear = event.from.year == event.to.year;

    final DateFormat dateFormat = DateFormat.MMMMd();
    final DateFormat timeFormat = DateFormat.jm();
    final String date = isSameDay
        ? dateFormat.format(event.from)
        : '${dateFormat.format(event.from)} - ${dateFormat.format(event.to)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget getColor(BuildContext context) {
    final String colorString = event.backgroundColor;
    final Color color = Color(int.parse(colorString, radix: 16));
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.5), color.withOpacity(0.2)],
          stops: [0.4, 0.8, 0.9],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: <Widget>[
              getColor(context),
              Container(
                padding:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? EdgeInsets.only(top: 60, left: 40, right: 40)
                        : EdgeInsets.only(top: 10, left: 40, right: 40),
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        event.title,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          fontSize: 40.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          buildDate(context, event.from, event.to),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Colors.grey,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            DateFormat.Hm().format(event.from) +
                                ' - ' +
                                DateFormat.Hm().format(event.to),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 20.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Created by: ' + event.userName,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.description,
                                color: Colors.grey,
                                size: 20.0,
                              ),
                              SizedBox(width: 10.0),
                              Text(
                                event.description,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditingPage(context, event),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          ActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Event'),
                    content:
                        Text('Are you sure you want to delete this event?'),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          _removeEvent(context, event);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Widget buildDateTime(Event event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (event.isAllDay)
          Text('All Day')
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, y').format(event.from),
                style: TextStyle(fontSize: 16),
              ),
              Text(
                DateFormat('h:mm a').format(event.from),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        SizedBox(width: 16),
        Icon(Icons.arrow_forward),
        SizedBox(width: 16),
        if (!event.isAllDay)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, y').format(event.to),
                style: TextStyle(fontSize: 16),
              ),
              Text(
                DateFormat('h:mm a').format(event.to),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
      ],
    );
  }

  Future _removeEvent(BuildContext context, Event event) async {
    final _event = event;

    await FirebaseFirestore.instance
        .collection('events')
        .doc(_event.id)
        .delete();
  }
}
