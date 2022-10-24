import 'dart:io';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:room8/widgets/pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this._submitAuthForm, this._isLoading);

  final bool _isLoading;

  final void Function(String email, String password, String userName,
      File image, bool isLogin, BuildContext ctx) _submitAuthForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();

      widget._submitAuthForm(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  key: const ValueKey('email'),
                  autocorrect: true,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => {
                    _userEmail = value,
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('userName'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: true,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Username is too short! Minimum 5 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Username - min 5 characters'),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password is too short! Minimum 7 characters';
                    }
                    return null;
                  },
                  decoration:
                      InputDecoration(labelText: 'Password - min 7 characters'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget._isLoading) CircularProgressIndicator(),
                if (!widget._isLoading)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    child: Text(_isLogin ? 'Login' : 'Signup'),
                    onPressed: _trySubmit,
                  ),
                if (!widget._isLoading)
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).primaryColorLight,
                    ),
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'I already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
