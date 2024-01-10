// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({Key? key}) : super(key: key);

  @override
  _AdminOrdersPageState createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  // this is the admin reserved products page that will give us a list of cards of reserved products with the
  // order details and the email of the user that make the order and also we have the address and the region of the user
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('reservedproducts');

  void confirmOrder(String orderId) async {
    // function that will delete the order when the admin click confirm with the id of the selected order
    await ordersCollection.doc(orderId).delete();
  }

  Future<void> updateOrderStatus(String orderId) async {
    // function that will update the order status to Shipped when the admin click confirm delivred order with the id of the selected order
    await FirebaseFirestore.instance
        .collection('reservedproducts')
        .doc(orderId)
        .update({'status': 'Shipped'});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [],
          title: Text(
            "Reserved products",
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
        body: StreamBuilder<QuerySnapshot>(
          stream: ordersCollection.snapshots(),
          builder: (context, snapshot) {
            // here we check in case has error return text widget with error message
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              // if loading we have the circular loading indicator
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // here we get each document and we display all data inside it
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                // here we get the productsData from the products array inside the reservedproducts
                List<dynamic>? productsData = data['products'];
                // if the order status is pending we list all the of the status pending products
                if (data["status"] == 'Pending') {
                  return Card(
                    color: Colors.blue[00],
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                'Email: ${data['userEmail']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              )
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: productsData!.map((product) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: 50.0,
                                          height: 50.0,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                product['imgPath']),
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Product: ${product['name']}'),
                                            Text('Price: ${product['price']}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Text(
                          "Status: ${data['status']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          'Total Price: ${data['totalPrice'] ?? 'No price'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Address: ${data['address']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.location_history),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Region: ${data['region']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.location_city),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'City: ${data['city']}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                updateOrderStatus(document.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Order Delivered.')),
                                );
                              },
                              child: Text(
                                'Mark as Delivered',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.grey,
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 25),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
