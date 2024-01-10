// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditProductPage extends StatefulWidget {
  @override
  _AdminEditProductPageState createState() => _AdminEditProductPageState();
}

class _AdminEditProductPageState extends State<AdminEditProductPage> {
  Future<void> editProduct(String productId, String newName, double newPrice,
      String newInfo) async {
    // function called editProduct that will update the fields of the selected
    // document from collection products with the given informations by the admin
    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .update({
      'name': newName,
      'price': newPrice,
      'information': newInfo
    });
  }

  Future _showEditDialog(
      // function called _showEditDialog that will show the dialog when the admin click edit product
      // it will give us 3 text field each one has the current product information
      BuildContext context,
      DocumentSnapshot product) async {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController infoController =
        TextEditingController(text: product['information']);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: infoController,
                  decoration: InputDecoration(labelText: 'Information'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              // when the user type the new data of the product and click update we call editProduct function
              // to update the the data of the product with the given product information
              child: Text('Update'),
              onPressed: () {
                editProduct(
                  product.id,
                  nameController.text,
                  double.parse(priceController.text),
                  infoController.text
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [],
        title: Text(
          "Edit Products",
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
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            // here we fetch all items inside the collection products and we diplay it
            // as ListTitle as the length of the documents inside the collection product
            // and finaly we display the name price and the image of it and we
            // have edit button when the user clicks edit they call the _showEditDialog with the product index
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot product = snapshot.data!.docs[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('\$${product['price']}'),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(product['imgPath']),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditDialog(context, snapshot.data!.docs[index]);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
