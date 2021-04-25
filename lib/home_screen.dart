import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_app/pages/events.dart';
import 'package:here_app/pages/host.dart';
import 'package:here_app/pages/profile.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String text = "empty";
  int currIndex = 1;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 65.0),
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () async {
              var result = await BarcodeScanner.scan();
              DocumentReference event = FirebaseFirestore.instance
                  .collection('events')
                  .doc(result.rawContent);
              event.update({
                'guests': FieldValue.arrayUnion([ProfilePage.userInfo])
              });
            },
            child: Icon(Icons.login),
          ),
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
              index: currIndex,
              children: [EventsPage(), ProfilePage(), HostPage()]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          currentIndex: currIndex,
          onTap: (int index) {
            setState(() {
              currIndex = index;
            });
          },
          items: allDestinations.map((Destination destination) {
            return BottomNavigationBarItem(
                icon: Icon(destination.icon),
                backgroundColor: destination.color,
                label: destination.title);
          }).toList(),
        ),
      ),
    );
  }
}

class Destination {
  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final MaterialColor color;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Events', Icons.explore, Colors.amber),
  Destination('Profile', Icons.person, Colors.amber),
  Destination('Host', Icons.event, Colors.amber)
];
