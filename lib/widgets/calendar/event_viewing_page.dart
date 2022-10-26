import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import 'event_editing_page.dart';
import 'event_provider.dart';

class EventViewingPage extends StatelessWidget {
  late final Event event;

  EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(context, event),
      ),
      body: ListView(
        padding: EdgeInsets.all(12),
        children: [
          buildDateTime(event),
          SizedBox(height: 32),
          Text(
            event.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Text(
            event.description,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          //create check box for selecting event as all day
          CheckboxListTile(
            title: Text("All Day"),
            value: event.isAllDay,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }

  List<Widget> buildEditingActions(BuildContext context, Event event) {
    return [
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditingPage(context),
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          Provider.of<EventProvider>(context, listen: false).remove(event);
          Navigator.pop(context);
        },
      ),
    ];
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
}
