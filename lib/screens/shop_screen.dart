import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:room8/screens/shop_details_screen.dart';

class ShopScreen extends StatefulWidget {
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  var _title = '';
  final fireStoreReference = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: fireStoreReference
            .collection('shop')
            .orderBy('name', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Card(
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Edit"),
                          value: 1,
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: 2,
                        ),
                        PopupMenuItem(
                          child: Text("Copy"),
                          value: 3,
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 1) {
                          //edit
                          _title = documentSnapshot['name'];
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Edit'),
                                  content: TextField(
                                    onChanged: (value) {
                                      _title = value;
                                    },
                                    controller: TextEditingController()
                                      ..text = _title,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        fireStoreReference
                                            .collection('shop')
                                            .doc(documentSnapshot.id)
                                            .update({'name': _title});
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                );
                              });
                        } else if (value == 2) {
                          fireStoreReference
                              .collection('shop')
                              .doc(documentSnapshot.id)
                              .delete();
                        } else if (value == 3) {
                          fireStoreReference
                              .collection('shop')
                              .doc(documentSnapshot.id)
                              .get()
                              .then(
                            (value) {
                              fireStoreReference.collection('shop').add({
                                'name': value['name'] +
                                    ' - Copy' +
                                    ' ' +
                                    DateTime.now().day.toString() +
                                    '.' +
                                    DateTime.now().month.toString() +
                                    '.' +
                                    DateTime.now().year.toString(),
                                'progress': 0.0,
                              }).then(
                                (value) => fireStoreReference
                                    .collection('shop')
                                    .doc(documentSnapshot.id)
                                    .collection('items')
                                    .get()
                                    .then(
                                      (items) => items.docs.forEach(
                                        (element) {
                                          fireStoreReference
                                              .collection('shop')
                                              .doc(value.id)
                                              .collection('items')
                                              .doc(element.id)
                                              .set({'checked': false});
                                        },
                                      ),
                                    ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    subtitle: Column(
                      children: [
                        LinearProgressIndicator(
                          value: documentSnapshot['progress'],
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailsScreen(
                            id: documentSnapshot.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add'),
                content: TextField(
                  onChanged: (value) {
                    _title = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      fireStoreReference.collection('shop').add({
                        'name': _title,
                        'progress': 0.0,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
