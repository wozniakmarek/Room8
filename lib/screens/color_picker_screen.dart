import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fast_color_picker/fast_color_picker.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({Key? key}) : super(key: key);

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Picker'),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            const Text(
              'Color Picker',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              'For the background color of the event and the user',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return FastColorPicker(
                      //height: 300,
                      //width: 300,

                      selectedColor: Color(
                        int.parse(snapshot.data!['color'], radix: 16),
                      ),
                      onColorSelected: (Color color) {
                        String colorString = color.value.toRadixString(16);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .update({'color': colorString});
                        FirebaseFirestore.instance
                            .collection('events')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            doc.reference
                                .update({'backgroundColor': colorString});
                          });
                          setState(() {});
                        });
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
