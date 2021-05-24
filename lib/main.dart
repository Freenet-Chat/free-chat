import 'package:free_chat/src/view.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: HomeTheme.getTheme(),
    home: Home()
    );}
}