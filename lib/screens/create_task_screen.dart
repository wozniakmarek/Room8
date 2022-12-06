import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;

  CreateTaskScreen(
    this.task,
  );

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  int _categoryController = 0;
  final _pointsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _categoryController = widget.task!.category;
      _pointsController.text = widget.task!.points.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Points',
                        ),
                        controller: _pointsController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a number of points';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Category',
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a category';
                          }
                          return null;
                        },
                        items: [
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.home_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Home'),
                              ],
                            ),
                            value: 0xf107,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.kitchen),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Kitchen'),
                              ],
                            ),
                            value: 0xe35e,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.bathtub_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Bathroom'),
                              ],
                            ),
                            value: 0xeebf,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.bed),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Room'),
                              ],
                            ),
                            value: 0xe0d7,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.living_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Living Room'),
                              ],
                            ),
                            value: 0xf170,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.shopping_basket_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Shopping'),
                              ],
                            ),
                            value: 0xf37e,
                          ),
                          DropdownMenuItem(
                            child: Row(
                              children: [
                                Icon(Icons.pets_outlined),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('Pets'),
                              ],
                            ),
                            value: 0xf285,
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _categoryController = value as int;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (widget.task != null) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.task!.id)
                          .update({
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'category': _categoryController,
                        'points': int.parse(_pointsController.text),
                        'selected': false,
                      });
                    } else {
                      FirebaseFirestore.instance.collection('tasks').add({
                        'title': _titleController.text,
                        'description': _descriptionController.text,
                        'category': _categoryController,
                        'points': int.parse(_pointsController.text),
                        'selected': false,
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
