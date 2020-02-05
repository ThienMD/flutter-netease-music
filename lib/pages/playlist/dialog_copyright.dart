import 'package:flutter/material.dart';

class DialogNoCopyRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(image: AssetImage("assets/no_copy_right.png")),
          Padding(padding: EdgeInsets.only(top: 16)),
          Text(
            "Sorry, this resource is temporarily unavailable.",
            textAlign: TextAlign.center,
          ),
          Padding(padding: EdgeInsets.only(top: 16))
        ],
      ),
    );
  }
}
