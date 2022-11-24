import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:room8/widgets/models/task.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../widgets/models/users.dart';

class ScheduleTaskScreen extends StatefulWidget {
  const ScheduleTaskScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleTaskScreen> createState() => _ScheduleTaskScreenState();
}

class _ScheduleTaskScreenState extends State<ScheduleTaskScreen> {
  List<Users> selectedUsers = [];
  List<Task> selectedTasks = [];
  int selectedRepeatMode = 0;
  List<Appointment> appointments = <Appointment>[];

  int repeatMode = 0;
  DateTime selectedDate = DateTime.now();
  List<DateTime> selectedDays = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .where('selected', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          selectedUsers.add(
            Users(
              id: doc.id,
              userName: doc['userName'],
              image_url: doc['image_url'],
              color: doc['color'],
            ),
          );
        });
      }
    });
    FirebaseFirestore.instance
        .collection('tasks')
        .where('selected', isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          selectedTasks.add(
            Task(
              title: doc['title'],
              description: doc['description'],
              category: doc['category'],
              points: doc['points'],
              id: doc.id,
            ),
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule Task'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              Text(
                'Repeat Mode',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            repeatMode = 0;
                          });
                        },
                        child: Text('Once'),
                        style: ElevatedButton.styleFrom(
                          primary: repeatMode == 0
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          onPrimary:
                              repeatMode == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            repeatMode = 1;
                          });
                        },
                        child: Text('Weekly'),
                        style: ElevatedButton.styleFrom(
                          primary: repeatMode == 1
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          onPrimary:
                              repeatMode == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (repeatMode == 0)
                    //show date picker for once and show selected date on right side
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            ).then((value) {
                              setState(() {
                                selectedDate = value!;
                              });
                            });
                          },
                          child: Text('Select Date: ' +
                              DateFormat.yMd().format(selectedDate)),
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Roommates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                width: double.infinity,
                height: 120,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    if (snapshot.data!.docs[index]
                                            ['selected'] ==
                                        true) {
                                      snapshot.data!.docs[index].reference
                                          .update({'selected': false});
                                      selectedUsers.removeWhere((element) =>
                                          element.id ==
                                          snapshot.data!.docs[index].id);
                                    } else {
                                      snapshot.data!.docs[index].reference
                                          .update({'selected': true});
                                      selectedUsers.add(
                                        Users(
                                          id: snapshot.data!.docs[index].id,
                                          userName: snapshot.data!.docs[index]
                                              ['userName'],
                                          image_url: snapshot.data!.docs[index]
                                              ['image_url'],
                                          color: snapshot.data!.docs[index]
                                              ['color'],
                                        ),
                                      );
                                    }
                                  });
                                },
                                child: Card(
                                  color: snapshot.data!.docs[index]
                                              ['selected'] ==
                                          true
                                      ? Colors.purple
                                      : Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(snapshot
                                              .data!.docs[index]['image_url']),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]['userName'],
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Container(
                width: double.infinity,
                height: 245,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tasks')
                        .orderBy('category', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  title:
                                      Text(snapshot.data!.docs[index]['title']),
                                  subtitle: Text(snapshot.data!.docs[index]
                                      ['description']),
                                  leading: Checkbox(
                                    value: snapshot.data!.docs[index]
                                        ['selected'],
                                    onChanged: (value) {
                                      setState(() {
                                        if (snapshot.data!.docs[index]
                                                ['selected'] ==
                                            true) {
                                          snapshot.data!.docs[index].reference
                                              .update({'selected': false});
                                        } else {
                                          snapshot.data!.docs[index].reference
                                              .update({'selected': true});
                                          selectedTasks.add(
                                            Task(
                                              id: snapshot.data!.docs[index].id,
                                              title: snapshot.data!.docs[index]
                                                  ['title'],
                                              description: snapshot.data!
                                                  .docs[index]['description'],
                                              category: snapshot.data!
                                                  .docs[index]['category'],
                                              points: snapshot.data!.docs[index]
                                                  ['points'],
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  trailing: Container(
                                    width: 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(IconData(
                                            snapshot.data!.docs[index]
                                                ['category'],
                                            fontFamily: 'MaterialIcons')),
                                        Text(snapshot
                                            .data!.docs[index]['points']
                                            .toString())
                                      ],
                                    ),
                                  ));
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedTasks.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select at least one task'),
                      ));
                    } else if (repeatMode == 1 && selectedDays.isEmpty ||
                        repeatMode == 2 && selectedDays.isEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please pick day'),
                      ));
                    else {
                      for (int i = 0; i < selectedUsers.length; i++) {
                        for (int j = 0; j < selectedTasks.length; j++) {
                          FirebaseFirestore.instance
                              .collection('challenges')
                              .add({
                            'isAllDay': true,
                            'from': DateTime(selectedDate.year,
                                selectedDate.month, selectedDate.day),
                            'to': DateTime(selectedDate.year,
                                selectedDate.month, selectedDate.day),
                            'title': selectedTasks[j].title,
                            'description': selectedTasks[j].description,
                            'category': selectedTasks[j].category,
                            'points': selectedTasks[j].points,
                            'isRecurrence': false,
                            'completed': false,
                            'userId': selectedUsers[i].id,
                            'userName': selectedUsers[i].userName,
                            'color': selectedUsers[i].color,
                            'recurrenceId': '',
                            'recurrenceRule': repeatMode == 0
                                ? null
                                : repeatMode == 1
                                    ? 'FREQ=DAILY;INTERVAL=1;COUNT=1'
                                    : repeatMode == 2
                                        ? 'FREQ=WEEKLY;BYDAY=${selectedDays.join(',')}'
                                        : 'FREQ=MONTHLY;BYMONTHDAY=${selectedDate.day}',
                            'exceptionDates': selectedDays.isEmpty
                                ? null
                                : repeatMode == 2
                                    ? selectedDays
                                    : null,
                          });
                        }
                      }
                      //update users and task to selected false
                      for (int i = 0; i < selectedUsers.length; i++) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(selectedUsers[i].id)
                            .update({'selected': false});
                      }
                      for (int i = 0; i < selectedTasks.length; i++) {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(selectedTasks[i].id)
                            .update({'selected': false});
                      }
                      //clear selected users and tasks
                      selectedUsers.clear();
                      selectedTasks.clear();
                      selectedDays.clear();

                      Navigator.of(context).pop();

                      //show message that challenge is created
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Challenge is created'),
                      ));
                    }
                  },
                  child: Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
