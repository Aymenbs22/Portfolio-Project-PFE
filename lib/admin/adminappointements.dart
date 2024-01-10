// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAppointements extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [],
        title: Text(
          "Appointements Page",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
      body: AppointementsList(),
    );
  }
}

class AppointementsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // here we have the appointements page of the admin here it will list all the appointements from collection appoitement
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('appointment').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // if not data we return loading indicator
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var forms = snapshot.data?.docs;
        List<Widget> formWidgets = [];
        for (var form in forms!) {
          // here we make a for loop of each form in forms we take the data of the form inside formData
          // then we separate it each one and we We organize and add them inside formWidgets to list them later as ListView
          var formData = form.data();

          formWidgets.add(
            Card(
              color: Colors.white,
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  'Name: ${formData['name']}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                subtitle: Text(
                    'Email: ${formData['Email']}\nHair Style: ${formData['selectedProduct']}\nType of Service: ${formData['selectedType']} \nPhone: ${formData['PhoneNumber']} \nNote: ${formData['description']}\nDate & Time: ${formData['date']} / ${formData['time']}',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                trailing: IconButton(
                  // here we have icon button for the admin when the appoitement is completed the admin can remove the appointement
                  // with the form id/index of the appoitement
                  icon: Icon(Icons.check),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('appointment')
                        .doc(form.id)
                        .delete();
                    // when the admin confirm the appoitement we get this SnackBar for confirmation
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Appointement confirmed and deleted')));
                  },
                ),
              ),
            ),
          );
        }

        return ListView(
          // here we list all widjets we add previusly
          children: formWidgets,
        );
      },
    );
  }
}
