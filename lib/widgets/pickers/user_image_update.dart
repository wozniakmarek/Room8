import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class UserImageUpdate extends StatefulWidget {
  UserImageUpdate(this._imagePickFn, DocumentSnapshot<Object?> snapshot);

  final void Function(File pickedImage) _imagePickFn;

  @override
  State<UserImageUpdate> createState() => _UserImageUpdateState();
}

class _UserImageUpdateState extends State<UserImageUpdate> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget._imagePickFn(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      if (_pickedImage != null)
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
      TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: _pickImage,
        icon: Icon(Icons.camera_alt),
        label: Text('Update Image'),
      ),
    ]);
  }
}
