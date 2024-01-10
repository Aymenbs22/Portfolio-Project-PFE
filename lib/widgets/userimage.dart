// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreImage extends StatelessWidget {
  final String documentId;
  final TextStyle? textStyle;

  FirestoreImage({required this.documentId, this.textStyle});

  @override
  Widget build(BuildContext context) {
    // here we have FirestoreImage that get it from the database whith the user id of the connected user
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
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
          return CircleAvatar(
            backgroundColor: Colors.grey[350],
            radius: 80,
            backgroundImage: NetworkImage("${data['imagelink']}"),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
