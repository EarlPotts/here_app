import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  static String id = "profile";
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Events page'),
    );
  }
}
