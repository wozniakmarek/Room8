// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:room8/screens/auth_screen.dart';
import 'package:room8/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:room8/screens/home_screen.dart';
import 'package:room8/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room8',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.purple,
        backgroundColor: Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
        accentColor: Color.fromARGB(255, 183, 20, 183),
        focusColor: Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      /*themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
        accentColor: Color.fromARGB(255, 183, 20, 183),
        focusColor: Color.fromARGB(255, 127, 13, 144).withOpacity(0.9),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Color.fromARGB(255, 80, 8, 91).withOpacity(0.9),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),*/
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              return HomeScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
