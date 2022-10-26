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
    BuildContext? buildContext, {
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  DateTime? _from;
  DateTime? _to;
  bool _isAllDay = false;
  bool _isLoading = false;

  @override
  void initState() {
    if (widget.event != null) {
      _from = widget.event!.from;
      _to = widget.event!.to;
    } else {
      final DateTime now = DateTime.now();
      _from = DateTime.now();
      _to = DateTime.now().add(Duration(hours: 2));
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _colorController.dispose();
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
                buildDates(),
                SizedBox(height: 8),
                /*buildAllDaySwitch(),
                if (!_allDay) buildTimeRange(),
                SizedBox(height: 8),
                buildNotes(),*/
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
    if (!isValid) return;

    final title = _titleController.text;
    final color = _colorController.text;
    final event = Event(
      title: title,
      description: 'description',
      from: _from as DateTime,
      to: _to as DateTime,
      isAllDay: false,
      key: _formKey.currentState.hashCode.toString(),
    );

    /////////////////////////FIRESTORE TIME/////////////////////////
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    await FirebaseFirestore.instance.collection('events').add(event.toMap());
    Navigator.of(context).pop();
    updateCalendar();
  }

  void updateCalendar() {
    setState(() {
      //update the calendar screen (calendar) with the new event added to the list of events in the calendar screen (list of events)
      //calendar.updateCalendar();
    });
  }
}
