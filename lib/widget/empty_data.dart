import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("NO DATA FOUNDED",
      textScaleFactor: 2.5,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontStyle: FontStyle.italic
        ),
      ),
    );
  }
}
