import 'package:flutter/material.dart';

import '../../utilis/constants.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: COLOR_GRAPE,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ));
  }
}
