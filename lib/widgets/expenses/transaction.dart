import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/src/widgets/container.dart';

import 'package:flutter/src/foundation/key.dart';

import '../../utilis/constants.dart';

class Mytransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final String expenseOrIncome;

  Mytransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
  });

  // final CollectionReference _expenses =
  //     FirebaseFirestore.instance.collection('expenses');

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //     body: StreamBuilder(
    //         stream: _expenses.snapshots(),
    //         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    //           if (streamSnapshot.hasData) {
    //             return ListView.builder(
    //                 itemCount: streamSnapshot.data!.docs.length,
    //                 itemBuilder: (context, index) {
    //                   final DocumentSnapshot documentSnapshot =
    //                       streamSnapshot.data!.docs[index];
    //                 });
    //           }
    //         }));
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
          color: COLOR_CREAM,
          height: 50,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(transactionName),
              Text(
                (expenseOrIncome == 'expense' ? '-' : '+') + '\$' + money,
                style: TextStyle(
                    color: expenseOrIncome == 'expense'
                        ? Colors.red
                        : Colors.green),
              )
            ],
          ))),
    );
  }
}
