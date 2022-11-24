import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Users {
  final String userName;
  final String image_url;
  final String id;
  final String color;

  Users({
    required this.userName,
    required this.image_url,
    required this.id,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'imageUrl': image_url,
      'id': id,
      'userName': userName,
      'color': color,
    };
  }

  factory Users.fromFireBaseSnapShotData(QuerySnapshot querySnapshot) {
    return Users(
      userName: querySnapshot.docs.first['userName'],
      image_url: querySnapshot.docs.first['imageUrl'],
      id: querySnapshot.docs.first.id,
      color: querySnapshot.docs.first['color'],
    );
  }
}
