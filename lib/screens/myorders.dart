// ignore_for_file: prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_12/screens/checkout.dart';
import 'package:flutter_application_12/screens/editprofile.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/screens/appointementpage.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../widgets/testbuttomnavbar.dart';

class MyOrdersPage extends StatefulWidget {
  // here we have my orders page this page will fetch the orders that related with the email of the current user
  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    void confirmOrder(String orderId) async {
      // function that will update the status of order when the admin click confirm with the id of the selected order
      await FirebaseFirestore.instance
          .collection('reservedproducts')
          .doc(orderId)
          .update({'status': 'Delivered'});
    }

    void DeleteconfirmedOrder(String orderId) async {
      // function that will delete the order when the admin click confirm with the id of the selected order
      await FirebaseFirestore.instance
          .collection('reservedproducts')
          .doc(orderId)
          .delete();
    }

    void _showRatingDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Rate Your Order'),
            content: RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    int _selectedIndex = 3;

    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyForm()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Checkout()),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyOrdersPage()),
        );
      } else if (index == 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage()),
        );
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "My Orders",
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
      body: user != null
          // here we check if the user not null we call the reservedproducts collection with the email of the user
          // then we check if there is no data or there is an error we return error message
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('reservedproducts')
                  .where('userEmail', isEqualTo: user.email)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(child: Text('Error or no data'));
                }

                return ListView(
                  // here we generates a list of products reserved for each doc using buildProductList
                  children: snapshot.data!.docs.map((doc) {
                    List<Widget> productList =
                        buildProductList(doc['products']);
                    productList.add(Divider());
                    productList.add(Text(
                      "Status: ${doc['status']}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ));
                    productList.add(Divider());
                    productList.add(
                      Text(
                        'Total Price: ${doc['totalPrice'] ?? 'No total price'}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    );
                    productList.add(
                      SizedBox(
                        height: 10,
                      ),
                    );
                    if (doc["status"] == 'Shipped') {
                      productList.add(
                        ElevatedButton(
                          onPressed: () {
                            _showRatingDialog(context);
                            confirmOrder(doc.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Order Delivery Confirmed. ')),
                            );
                          },
                          child: Text(
                            'Confirm Delivery',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.grey,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                          ),
                        ),
                      );
                    }
                    if (doc["status"] == 'Delivered') {
                      productList.add(
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Thanks for shopping with us.')),
                            );
                            DeleteconfirmedOrder(doc.id);
                          },
                          child: Text(
                            'Delete Confirmed Order',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 25),
                          ),
                        ),
                      );
                    }

                    return Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: productList,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          : Center(child: Text('User not logged in')),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  List<Widget> buildProductList(products) {
    // this function make a list of products and for each product
    // in products this create a row with the products deatails we
    // also add check in case there is no product or there is a problem

    List<Widget> productWidgets = [];
    if (products == null) {
      productWidgets.add(Text('No products'));
      return productWidgets;
    }
    for (var product in products) {
      productWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              product['imgPath'] != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(
                        product['imgPath'],
                      ),
                      radius: 30,
                    )
                  : SizedBox(width: 100, height: 100),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product['name'] ?? 'No title'}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Price: ${product['price'] ?? 'No price'}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return productWidgets;
  }
}
