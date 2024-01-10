// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserNametodrawer extends StatefulWidget {
  final String documentId;
  final TextStyle? textStyle;

  GetUserNametodrawer({required this.documentId, this.textStyle});

  @override
  State<GetUserNametodrawer> createState() => _GetUserNametodrawerState();
}

class _GetUserNametodrawerState extends State<GetUserNametodrawer> {
  @override
  Widget build(BuildContext context) {
    // here we have user name drawer that will give us text widget
    // with the username of the logged in user to display it in the drawer
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(
            "${data['username']}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
