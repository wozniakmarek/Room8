// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:neon/neon.dart';
import 'package:room8/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  List<Color> _colorCollection = <Color>[];

  void _submitAuthForm(
    String email,
    String userName,
    String password,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        super.dispose();
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        _initializeEventColor();
        final color = _colorCollection[Random().nextInt(9)];
        String colorString = color.toString(); // Color(0x12345678)
        String valueColorString = colorString.split('(0x')[1].split(')')[0];
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': email,
          'image_url': url,
          'phone': '',
          'color': valueColorString,
        });
        super.dispose();
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      super.dispose();
    } catch (err) {
      print(err);
      _isLoading = false;
    }
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.9),
                  Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /* if (MediaQuery.of(context).orientation !=
                      Orientation.landscape)
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Neon(
                          text: 'Room8',
                          color: Colors.blue,
                          fontSize: 50,
                          font: NeonFont.Beon,
                          flickeringText: true,
                          flickeringLetters: [4],
                        ),
                      ),
                    ),*/
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    width: deviceSize.width * 0.85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(
                            0,
                            2,
                          ),
                        )
                      ],
                    ),
                    child: AuthForm(_submitAuthForm, _isLoading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
