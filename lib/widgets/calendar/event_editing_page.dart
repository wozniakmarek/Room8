import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import 'event_provider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage(
    BuildContext? buildContext,
    this.event,
  );

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Color> _colorCollection = <Color>[];

  DateTime? _from;
  DateTime? _to;
  bool _isAllDay = false;
  bool _isLoading = false;
  late Color _color;

  @override
  void initState() {
    _initializeEventColor();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _from = widget.event!.from;
      _to = widget.event!.to;
      _isAllDay = widget.event!.isAllDay;
      _color = Color(int.parse(widget.event!.backgroundColor, radix: 16));
    } else {
      _from = DateTime.now();
      _to = DateTime.now().add(const Duration(hours: 1));
      _color = _colorCollection[Random().nextInt(9)];
    }

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildTitle(),
                SizedBox(height: 8),
                SizedBox(height: 8),
                buildAllDaySwitch(),
                buildDates(),
                SizedBox(height: 8),
                buildNotes(),
              ],
            ),
          )),
    );
  }

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          onPressed: () => _saveForm(),
          icon: Icon(Icons.done),
          label: Text('Save'),
        ),
      ];

  Widget buildTitle() => TextFormField(
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Title',
        ),
        onFieldSubmitted: (value) => _saveForm(),
        validator: (title) =>
            title!.isEmpty ? 'Tytuł nie może być pusty.' : null,
        controller: _titleController,
      );

  Widget buildDates() => Column(
        children: [
          buildFrom(),
          SizedBox(height: 8),
          buildTo(),
        ],
      );
  Widget buildAllDaySwitch() => Row(
        children: [
          Text('All day'),
          Switch(
            value: _isAllDay,
            onChanged: (value) => setState(() => _isAllDay = value),
          ),
        ],
      );
  Widget buildNotes() => TextFormField(
        maxLines: 10,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Notes',
        ),
        controller: _descriptionController,
      );
  Widget buildFrom() => buildHeader(
        header: 'Od',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                //give text value from _from and DateFormat.yMMMEd().format(_from)
                text: DateFormat.yMMMEd().format(_from!),
                onClicked: () => pickFromDateTime(pickDate: true),
              ),
            ),
            if (!_isAllDay)
              Expanded(
                child: buildDropDownField(
                  text: DateFormat.Hm().format(_from!),
                  onClicked: () => pickFromDateTime(pickDate: false),
                ),
              ),
          ],
        ),
      );

  Widget buildDropDownField({required String text, onClicked}) => ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Row child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      );

  Widget buildTo() => buildHeader(
        header: 'Do',
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropDownField(
                text: DateFormat.yMMMEd().format(_to!),
                onClicked: () => pickToDateTime(pickDate: true),
              ),
            ),
            if (!_isAllDay)
              Expanded(
                child: buildDropDownField(
                  text: DateFormat.Hm().format(_to!),
                  onClicked: () => pickToDateTime(pickDate: false),
                ),
              ),
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_from!, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(_to!)) {
      _to = date;
    }

    setState(() {
      _from = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(_to!, pickDate: pickDate);
    if (date == null) return;

    if (date.isBefore(_from!)) {
      _from = date;
    }

    setState(() {
      _to = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Future _saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    final title = _titleController.text;
    final description = _descriptionController.text;
    final color = _color;
    String colorString = color.toString(); // Color(0x12345678)
    String valueColorString = colorString.split('(0x')[1].split(')')[0];

    final event = Event(
      title: title,
      description: _descriptionController.text,
      from: _from as DateTime,
      to: _to as DateTime,
      isAllDay: _isAllDay,
      backgroundColor: valueColorString,
      id: widget.event?.id,
    );
    //check if event is added or modify
    if (widget.event == null) {
      _addEventToFirestore(event);
    } else {
      _updateEventInFirestore(event);
      //create dialog to inform user about success
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Event has been updated'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    ;

    Navigator.of(context).pop();
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

  void _updateEventInFirestore(Event event) {
    FirebaseFirestore.instance
        .collection('events')
        .doc(event.id)
        .update(event.toMap());
  }

  Future<void> _addEventToFirestore(Event event) async {
    // get ref to the event document
    DocumentReference eventRef =
        FirebaseFirestore.instance.collection('events').doc();

    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    // add event to firestore
    event.id = eventRef.id;
    event.userId = user.uid;
    event.userName = userData['userName'];
    eventRef.set(event.toMap());
  }
}
