import 'package:flutter/material.dart';

class University extends StatefulWidget {
  @override
  _UniversityState createState() => _UniversityState();
}

class _UniversityState extends State<University> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University'),
      ),
      body: Center(
        child: Text('University'),
      ),
    );	
  }
}

