import 'package:flutter/material.dart';
import 'package:government/login.dart';

void main() {
  runApp(const MyApp());
}

var globalAccount;
var profileSession;
var globalConnector;
var globalUri;
String url = "eb57-2405-201-1f-f946-dcb8-6bd9-4729-abce.ngrok.io";

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
