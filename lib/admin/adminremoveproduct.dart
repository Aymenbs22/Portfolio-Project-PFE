// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      home: ProductRemovePage(),
    );
  }
}

class ProductRemovePage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void deleteProduct(String productId) async {
    // function that delete the document with the given productid
    await firestore.collection('products').doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Remove Products",
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
      body: StreamBuilder(
        // here we will display all the products from the products collection as a cards and each product has a delete button with his id
        stream: firestore.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(data["imgPath"]),
                  ),
                  title: Text(data['name'] ?? 'No Name'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    // here we will call the deleteProduct method and we give it the document id of selected product
                    onPressed: () => deleteProduct(document.id),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
