// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room8/widgets/pickers/user_image_picker.dart';
import 'package:room8/widgets/pickers/user_image_update.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {}).catchError((error) {});
    }).catchError((err) {});
  }

  void _updateUser(
    String email,
    String userName,
    String password,
    File? image,
    String currentPassword,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });

      _changePassword(currentPassword, password);
      final user = await FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(user!.uid + DateTime.now().second.toString() + '.jpg');
      await ref.putFile(image!);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'email': email,
        'userName': userName,
        'image_url': url,
      });

      await FirebaseFirestore.instance
          .collection('chat')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('chat')
              .doc(element.id)
              .update({'userName': userName, 'image_url': url});
        });
      });

      await FirebaseFirestore.instance
          .collection('events')
          .where('userId', isEqualTo: user.uid)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          FirebaseFirestore.instance
              .collection('events')
              .doc(element.id)
              .update({'userName': userName});
        });
      });

      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData)
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: UpdateForm(_updateUser, snapshot.data!),
                ),
              );
            else
              return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class UpdateForm extends StatefulWidget {
  UpdateForm(this._updateUser, this.snapshot);

  final void Function(
    String email,
    String userName,
    String password,
    File? image,
    String currentPassword,
    BuildContext ctx,
  ) _updateUser;
  final DocumentSnapshot snapshot;

  @override
  State<UpdateForm> createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userCurrentPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      widget._updateUser(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _userCurrentPassword.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserImageUpdate(_pickedImage, widget.snapshot),
          TextFormField(
            key: const ValueKey('email'),
            initialValue: widget.snapshot['email'],
            validator: (value) {
              if (value!.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email address.';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email address'),
            onSaved: (value) {
              _userEmail = value!;
            },
          ),
          TextFormField(
            key: const ValueKey('userName'),
            initialValue: widget.snapshot['userName'],
            validator: (value) {
              if (value!.isEmpty || value.length < 4) {
                return 'Please enter at least 4 characters.';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Username'),
            onSaved: (value) {
              _userName = value!;
            },
          ),
          TextFormField(
            key: const ValueKey('currentPassword'),
            validator: (value) {
              if (value!.isEmpty || value.length < 7) {
                return 'Password must be at least 7 characters long.';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Current Password'),
            obscureText: true,
            onSaved: (value) {
              _userCurrentPassword = value!;
            },
          ),
          TextFormField(
            key: const ValueKey('password'),
            validator: (value) {
              if (value!.isEmpty || value.length < 7) {
                return 'Password must be at least 7 characters long.';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) {
              _userPassword = value!;
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            child: const Text('Update'),
            onPressed: _trySubmit,
          ),
        ],
      ),
    );
  }
}
