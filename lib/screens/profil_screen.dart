import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room8/screens/color_picker_screen.dart';
import 'package:room8/screens/roommates_screen.dart';
import 'package:room8/screens/settings_screen.dart';

class ProfilScreen extends StatefulWidget {
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  _updateDetails(
    String userName,
    String userEmail,
    File? image,
    String userPassword,
  ) async {
    UserCredential authResult;
    try {
      authResult = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);
      super.dispose();
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user!.uid + '.jpg');
      await ref.putFile(image!);
      final url = await ref.getDownloadURL();

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'userName': userName,
        'email': userEmail,
        'image_url': url,
      });
      super.dispose();
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials!';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(snapshot.data!['color'], radix: 16)),
                      ),
                      accountName: Text(snapshot.data!['userName']),
                      accountEmail: Text(snapshot.data!['email']),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data!['image_url']),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.group),
                      title: Text('Roommates'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RoommatesScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.color_lens),
                      title: Text('Set your color'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ColorPickerScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
