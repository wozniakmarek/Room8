import 'dart:io';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this._imagePickFn);

  final void Function(File pickedImage) _imagePickFn;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker().getImage(
      source: ImageSource.camera,
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
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
      ),
      TextButton.icon(
        style: TextButton.styleFrom(
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: _pickImage,
        icon: Icon(Icons.camera_alt),
        label: Text('Add Image'),
      ),
    ]);
  }
}
