import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:here_app/onboarding_widgets.dart';
import 'package:logger/logger.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../main.dart';

class HostPage extends StatefulWidget {
  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  String? newEventTitle, newEventId;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (newEventId != null)
            Center(
                child: Text(
              newEventTitle!,
              style: TextStyle(fontSize: 13),
            )),
          if (newEventId != null) QrImage(data: newEventId!),
          OnboardButton(
            fill: Colors.amber,
            text: "New Event",
            onPressed: () async {
              String title = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(content: CreateEventPopup());
                  });
              createEvent(title);
            },
          )
        ],
      ),
    );
  }

  void createEvent(String title) async {
    DocumentReference? event;
    await FirebaseFirestore.instance.collection('events').add({
      'title': title,
      'host': FirebaseAuth.instance.currentUser?.uid,
      'guests': []
    }).then((value) {
      event = value;
      MyApp.showToast('Success!');
    }).catchError((e) {
      MyApp.showToast(e.toString());
      return;
    });

    setState(() {
      newEventTitle = title;
      newEventId = event?.id;
    });
  }
}

class CreateEventPopup extends StatefulWidget {
  @override
  _CreateEventPopupState createState() => _CreateEventPopupState();
}

class _CreateEventPopupState extends State<CreateEventPopup> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -15.0,
          top: -15.0,
          child: InkResponse(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              child: Icon(
                Icons.close,
                size: 15,
              ),
              backgroundColor: Colors.red,
              radius: 15,
            ),
          ),
        ),
        Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SignInField(
                validator: (value) {
                  value = value ?? '';
                  if (value.length < 5)
                    return "Please enter at least 5 charactrs for the title";
                  return null;
                },
                onChanged: (value) {
                  title = value;
                },
                obscure: false,
                hint: 'Enter name of event',
                isLast: true,
                inputType: TextInputType.text),
            OnboardButton(
              fill: Colors.amber,
              text: "Create Event",
              onPressed: () {
                Logger().d('title before pop: $title');
                Navigator.pop(context, title);
              },
            )
          ],
        ))
      ],
    );
  }
}

class Event {
  final String title, id;

  Event(this.title, this.id);
}
