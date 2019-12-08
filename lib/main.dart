import 'package:flutter/material.dart';
import 'package:flutter_sqlite_from_tuto/widget/home_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomeController(title: 'I Want...'),
      debugShowCheckedModeBanner: false,
    );
  }
}

