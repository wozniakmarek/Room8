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
  List<int> selectedDaysOfWeek = [];
  List<int> selectedDaysOfMonth = [];
  //selectedDaysOfWeekString
  List<String> selectedDaysOfWeekString = [];

  //create list of users from firebase collection
  List<Users> users = [];
  List<Task> tasks = [];

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
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            repeatMode = 2;
                          });
                        },
                        child: Text('Monthly'),
                        style: ElevatedButton.styleFrom(
                          primary: repeatMode == 2
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor,
                          onPrimary:
                              repeatMode == 2 ? Colors.white : Colors.black,
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
                  if (repeatMode == 1)
                    //show row with buttons with days of week
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.monday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.monday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.monday)) {
                                  selectedDaysOfWeek.remove(DateTime.monday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.monday);
                                }
                              });
                            },
                            child: Text('Monday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.tuesday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.tuesday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.tuesday)) {
                                  selectedDaysOfWeek.remove(DateTime.tuesday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.tuesday);
                                }
                              });
                            },
                            child: Text('Tuesday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: selectedDaysOfWeek
                                      .contains(DateTime.wednesday)
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).primaryColor,
                              onPrimary: selectedDaysOfWeek
                                      .contains(DateTime.wednesday)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.wednesday)) {
                                  selectedDaysOfWeek.remove(DateTime.wednesday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.wednesday);
                                }
                              });
                            },
                            child: Text('Wednesday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.thursday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.thursday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.thursday)) {
                                  selectedDaysOfWeek.remove(DateTime.thursday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.thursday);
                                }
                              });
                            },
                            child: Text('Thursday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.friday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.friday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.friday)) {
                                  selectedDaysOfWeek.remove(DateTime.friday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.friday);
                                }
                              });
                            },
                            child: Text('Friday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.saturday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.saturday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.saturday)) {
                                  selectedDaysOfWeek.remove(DateTime.saturday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.saturday);
                                }
                              });
                            },
                            child: Text('Saturday'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  selectedDaysOfWeek.contains(DateTime.sunday)
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColor,
                              onPrimary:
                                  selectedDaysOfWeek.contains(DateTime.sunday)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                if (selectedDaysOfWeek
                                    .contains(DateTime.sunday)) {
                                  selectedDaysOfWeek.remove(DateTime.sunday);
                                } else {
                                  selectedDaysOfWeek.add(DateTime.sunday);
                                }
                              });
                            },
                            child: Text('Sunday'),
                          ),
                        ],
                      ),
                    ),
                  if (repeatMode == 2)
                    //show text "Choose a day of the month"
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        'Choose a day of the month',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  if (repeatMode == 2)
                    Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(1)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(1)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(1)) {
                                    selectedDaysOfMonth.remove(1);
                                  } else {
                                    selectedDaysOfMonth.add(1);
                                  }
                                });
                              },
                              child: Text('1'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(2)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(2)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(2)) {
                                    selectedDaysOfMonth.remove(2);
                                  } else {
                                    selectedDaysOfMonth.add(2);
                                  }
                                });
                              },
                              child: Text('2'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(3)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(3)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(3)) {
                                    selectedDaysOfMonth.remove(3);
                                  } else {
                                    selectedDaysOfMonth.add(3);
                                  }
                                });
                              },
                              child: Text('3'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(4)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(4)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(4)) {
                                    selectedDaysOfMonth.remove(4);
                                  } else {
                                    selectedDaysOfMonth.add(4);
                                  }
                                });
                              },
                              child: Text('4'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(5)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(5)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(5)) {
                                    selectedDaysOfMonth.remove(5);
                                  } else {
                                    selectedDaysOfMonth.add(5);
                                  }
                                });
                              },
                              child: Text('5'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(6)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(6)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(6)) {
                                    selectedDaysOfMonth.remove(6);
                                  } else {
                                    selectedDaysOfMonth.add(6);
                                  }
                                });
                              },
                              child: Text('6'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(7)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(7)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(7)) {
                                    selectedDaysOfMonth.remove(7);
                                  } else {
                                    selectedDaysOfMonth.add(7);
                                  }
                                });
                              },
                              child: Text('7'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(8)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(8)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(8)) {
                                    selectedDaysOfMonth.remove(8);
                                  } else {
                                    selectedDaysOfMonth.add(8);
                                  }
                                });
                              },
                              child: Text('8'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(9)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(9)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(9)) {
                                    selectedDaysOfMonth.remove(9);
                                  } else {
                                    selectedDaysOfMonth.add(9);
                                  }
                                });
                              },
                              child: Text('9'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(10)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(10)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(10)) {
                                    selectedDaysOfMonth.remove(10);
                                  } else {
                                    selectedDaysOfMonth.add(10);
                                  }
                                });
                              },
                              child: Text('10'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(11)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(11)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(11)) {
                                    selectedDaysOfMonth.remove(11);
                                  } else {
                                    selectedDaysOfMonth.add(11);
                                  }
                                });
                              },
                              child: Text('11'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(12)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(12)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(12)) {
                                    selectedDaysOfMonth.remove(12);
                                  } else {
                                    selectedDaysOfMonth.add(12);
                                  }
                                });
                              },
                              child: Text('12'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(13)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(13)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(13)) {
                                    selectedDaysOfMonth.remove(13);
                                  } else {
                                    selectedDaysOfMonth.add(13);
                                  }
                                });
                              },
                              child: Text('13'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(14)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(14)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(14)) {
                                    selectedDaysOfMonth.remove(14);
                                  } else {
                                    selectedDaysOfMonth.add(14);
                                  }
                                });
                              },
                              child: Text('14'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(15)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(15)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(15)) {
                                    selectedDaysOfMonth.remove(15);
                                  } else {
                                    selectedDaysOfMonth.add(15);
                                  }
                                });
                              },
                              child: Text('15'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(16)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(16)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(16)) {
                                    selectedDaysOfMonth.remove(16);
                                  } else {
                                    selectedDaysOfMonth.add(16);
                                  }
                                });
                              },
                              child: Text('16'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(17)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(17)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(17)) {
                                    selectedDaysOfMonth.remove(17);
                                  } else {
                                    selectedDaysOfMonth.add(17);
                                  }
                                });
                              },
                              child: Text('17'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(18)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(18)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(18)) {
                                    selectedDaysOfMonth.remove(18);
                                  } else {
                                    selectedDaysOfMonth.add(18);
                                  }
                                });
                              },
                              child: Text('18'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(19)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(19)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(19)) {
                                    selectedDaysOfMonth.remove(19);
                                  } else {
                                    selectedDaysOfMonth.add(19);
                                  }
                                });
                              },
                              child: Text('19'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(20)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(20)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(20)) {
                                    selectedDaysOfMonth.remove(20);
                                  } else {
                                    selectedDaysOfMonth.add(20);
                                  }
                                });
                              },
                              child: Text('20'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(21)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(21)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(21)) {
                                    selectedDaysOfMonth.remove(21);
                                  } else {
                                    selectedDaysOfMonth.add(21);
                                  }
                                });
                              },
                              child: Text('21'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(22)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(22)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(22)) {
                                    selectedDaysOfMonth.remove(22);
                                  } else {
                                    selectedDaysOfMonth.add(22);
                                  }
                                });
                              },
                              child: Text('22'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(23)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(23)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(23)) {
                                    selectedDaysOfMonth.remove(23);
                                  } else {
                                    selectedDaysOfMonth.add(23);
                                  }
                                });
                              },
                              child: Text('23'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(24)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(24)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(24)) {
                                    selectedDaysOfMonth.remove(24);
                                  } else {
                                    selectedDaysOfMonth.add(24);
                                  }
                                });
                              },
                              child: Text('24'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(25)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(25)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(25)) {
                                    selectedDaysOfMonth.remove(25);
                                  } else {
                                    selectedDaysOfMonth.add(25);
                                  }
                                });
                              },
                              child: Text('25'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(26)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(26)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(26)) {
                                    selectedDaysOfMonth.remove(26);
                                  } else {
                                    selectedDaysOfMonth.add(26);
                                  }
                                });
                              },
                              child: Text('26'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(27)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(27)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(27)) {
                                    selectedDaysOfMonth.remove(27);
                                  } else {
                                    selectedDaysOfMonth.add(27);
                                  }
                                });
                              },
                              child: Text('27'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(28)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(28)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(28)) {
                                    selectedDaysOfMonth.remove(28);
                                  } else {
                                    selectedDaysOfMonth.add(28);
                                  }
                                });
                              },
                              child: Text('28'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(29)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(29)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(29)) {
                                    selectedDaysOfMonth.remove(29);
                                  } else {
                                    selectedDaysOfMonth.add(29);
                                  }
                                });
                              },
                              child: Text('29'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(30)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(30)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(30)) {
                                    selectedDaysOfMonth.remove(30);
                                  } else {
                                    selectedDaysOfMonth.add(30);
                                  }
                                });
                              },
                              child: Text('30'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: selectedDaysOfMonth.contains(31)
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).primaryColor,
                                onPrimary: selectedDaysOfMonth.contains(31)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (selectedDaysOfMonth.contains(31)) {
                                    selectedDaysOfMonth.remove(31);
                                  } else {
                                    selectedDaysOfMonth.add(31);
                                  }
                                });
                              },
                              child: Text('31'),
                            ),
                          ],
                        ),
                      ),
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
                height: 225,
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
                    } else if (repeatMode == 1 && selectedDaysOfWeek.isEmpty)
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please pick day'),
                      ));
                    else {
                      if (repeatMode == 1) {
                        //change selectedDayofWeek from int to 'MO', 'TU' etc
                        selectedDaysOfWeek.forEach((element) {
                          switch (element) {
                            case 1:
                              selectedDaysOfWeekString.add('MO');
                              break;
                            case 2:
                              selectedDaysOfWeekString.add('TU');
                              break;
                            case 3:
                              selectedDaysOfWeekString.add('WE');
                              break;
                            case 4:
                              selectedDaysOfWeekString.add('TH');
                              break;
                            case 5:
                              selectedDaysOfWeekString.add('FR');
                              break;
                            case 6:
                              selectedDaysOfWeekString.add('SA');
                              break;
                            case 7:
                              selectedDaysOfWeekString.add('SU');
                              break;
                          }
                        });
                      }
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
                            'recurrenceRule': repeatMode == 1
                                ? 'FREQ=WEEKLY;INTERVAL=1;BYDAY=${selectedDaysOfWeekString.join(',')}'
                                : null,
                            'exceptionDates': null,
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
