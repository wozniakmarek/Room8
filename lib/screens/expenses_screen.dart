import 'package:flutter/foundation.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room8/widgets/expenses/top_card.dart';

import '../utilis/constants.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  var _name = '';
  int _amount = 0;
  bool _income = false;
  final date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // margin: EdgeInsets.only(),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('expenses')
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents = streamSnapshot.data!.docs;
                  return TopCardExpenses(
                    balance: '\$' +
                        documents
                            .map((e) => e['amount'])
                            .reduce((value, element) => value + element)
                            .toString(),
                    income: '\$500',
                    expense: '\$300',
                  );
                },
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('expenses')
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    if (streamSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final documents = streamSnapshot.data!.docs;
                    return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (ctx, index) => Container(
                              padding: EdgeInsets.only(top: 18),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                    padding: EdgeInsets.all(12),
                                    color: COLOR_CREAM,
                                    height: 48,
                                    child: Center(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Text(documents[index]['name']),
                                          Text(
                                            '\$' +
                                                documents[index]['amount']
                                                    .toString(),
                                          )
                                        ]))),
                              ),
                            ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              // var _name = '';
              // var _amount = '';
              return AlertDialog(
                backgroundColor: COLOR_ABLUE,
                title: Center(child: Text('Add expense')),
                content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Switch(
                          //   value: _income,
                          //   onChanged: (bool value) {
                          //     setState(() {
                          //       _income = value;
                          //     });
                          //   },
                          // ),
                          TextFormField(
                            onChanged: (value) {
                              _name = value;
                            },
                            decoration:
                                const InputDecoration(hintText: 'Details'),
                          ),
                          TextFormField(
                            onChanged: (value) {
                              _amount = int.parse(value);
                            },
                            decoration:
                                const InputDecoration(hintText: 'amount'),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    )),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('expenses').add({
                        'name': _name,
                        'amount': _amount,
                        'income': _income,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
