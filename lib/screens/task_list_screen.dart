import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/models/task.dart';
import 'create_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('category', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Dismissible(
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 16)),
                      Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(padding: EdgeInsets.only(right: 16)),
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    FirebaseFirestore.instance
                        .collection('tasks')
                        .doc(document.id)
                        .delete();
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateTaskScreen(
                          Task.fromMap(data, document.id),
                        ),
                      ),
                    );
                  }
                },
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['description']),
                  trailing: Container(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(IconData(data['category'],
                            fontFamily: 'MaterialIcons')),
                        Text(data['points'].toString()),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
