import 'package:flutter/material.dart';
import 'package:room8/utilis/constants.dart';

class TopCardExpenses extends StatelessWidget {
  final String balance;
  final String income;
  final String expense;

  TopCardExpenses(
      {required this.balance, required this.income, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: COLOR_CREAM,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4.0, -4.0),
                  blurRadius: 15,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                  Text('B A L A N C E',
                      style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  Text(balance,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Icon(
                  //           Icons.arrow_upward,
                  //           color: Colors.green,
                  //         ),
                  //         Text('income'),
                  //         Text(income),
                  //       ],
                  //     ),
                  //     Row(
                  //       children: [
                  //         Icon(
                  //           Icons.arrow_downward,
                  //           color: Colors.red,
                  //         ),
                  //         Text('expense'),
                  //         Text(expense),
                  //       ],
                  //     )
                  //   ],
                  // )
                ]))));
  }
}
