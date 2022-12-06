import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room8/screens/user_profile_screen.dart';

class RoommatesScreen extends StatefulWidget {
  const RoommatesScreen({Key? key}) : super(key: key);

  @override
  State<RoommatesScreen> createState() => _RoommatesScreenState();
}

class _RoommatesScreenState extends State<RoommatesScreen> {
  @override
  Widget build(BuildContext context) {
    var phone = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roommates'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              phone = snapshot.data!['phone'];
              if (phone == '') {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Add your phone number to see your roommates',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 300,
                        child: TextField(
                          onChanged: (value) {
                            phone = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone number',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'phone': phone});
                          },
                          child: const Text('Submit'))
                    ],
                  ),
                );
              } else {
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                                Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
                              ],
                              stops: [0, 1],
                            ),
                          ),
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserProfileScreen(
                                            userId:
                                                snapshot.data!.docs[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    tileColor: Color(int.parse(
                                        snapshot.data!.docs[index]['color'],
                                        radix: 16)),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(snapshot
                                          .data!.docs[index]['image_url']),
                                    ),
                                    title: Text(
                                        snapshot.data!.docs[index]['userName']),
                                    subtitle: Text(
                                        snapshot.data!.docs[index]['phone']),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
