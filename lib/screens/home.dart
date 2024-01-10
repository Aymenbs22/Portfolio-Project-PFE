// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/classes/itemclass.dart';
import 'package:flutter_application_12/admin/admindashboard.dart';
import 'package:flutter_application_12/screens/checkout.dart';
import 'package:flutter_application_12/screens/editprofile.dart';
import 'package:flutter_application_12/screens/login.dart';
import 'package:flutter_application_12/screens/myorders.dart';
import 'package:flutter_application_12/screens/productspage.dart';
import 'package:flutter_application_12/screens/appointementpage.dart';
import 'package:flutter_application_12/provider/cart.dart';
import 'package:flutter_application_12/widgets/appbar.dart';
import 'package:flutter_application_12/widgets/drawerdata.dart';
import 'package:flutter_application_12/widgets/testbuttomnavbar.dart';
import 'package:flutter_application_12/widgets/userimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final credential = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    final classInstancee = Provider.of<Cart>(context);
    // here we will make an instance of class cart that has a
    // list called selectedproducts and when we click on add button it will be added to the list
    // and can also delete item from the cart and when anythink change inside the class
    // it will re build to the build Widget using notifyListeners
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(3, 18, 3, 18),
        child: FutureBuilder<List<Product>>(
            // here we call getProductsFromDatabase function that will return as list of Product objects
            future: getProductsFromDatabase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // here we return CircularProgressIndicator to avoid problem of getting data delai
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                List<Product> products = snapshot.data ?? [];

                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        // when the user clicks on the item he will go to product information of the selected item with his index
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Products(product: products[index]),
                            ),
                          );
                        },
                        child: GridTile(
                          footer: Padding(
                            padding: const EdgeInsets.fromLTRB(2, 0, 2, 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              child: GridTileBar(
                                // here we have a button so when the user clicks on the add button the item will be added to the cart
                                backgroundColor: Color.fromARGB(178, 0, 0, 0),
                                trailing: IconButton(
                                    color: Color.fromARGB(255, 62, 94, 70),
                                    onPressed: () {
                                      classInstancee
                                          .addproduct(products[index]);
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )),
                                leading: Container(
                                  // here we have the product name and the price of it from the obj
                                  width: 100,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${products[index].name}",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "\$${products[index].price}",
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Container(),
                              ),
                            ),
                          ),
                          child: Stack(children: [
                            // here we have the stack of the image this will give us the product image of each item in the list
                            Positioned(
                              left: 2,
                              right: 2,
                              top: 0,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      Image.network(products[index].imgPath)),
                            ),
                          ]),
                        ),
                      );
                    });
              } else {
                return Text("No products found");
              }
            }),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        // Bottom Nav bar
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
      drawer: Drawer(
        // Here we have the drawer that will give us the image and the
        // email of the user from the firestore file and also we can logout from the account
        child: Column(children: [
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150.0,
                    height: 150.0,
                    child: FirestoreImage(
                      documentId: credential!.uid,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  GetUserNametodrawer(
                    documentId: credential!.uid,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "${credential!.email.toString()}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            },
            leading: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              "Home",
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            title: Text(
              "Logout",
              style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
            ),
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onTap: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              }).catchError((error) {});
            },
          ),
          Divider(
            color: Colors.grey,
            height: 4.0,
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.help,
              color: Colors.black,
            ),
            title: Text("Help"),
          ),
        ]),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                var data = snapshot.data!.data() as Map<String, dynamic>;
                if (data.containsKey('isAdmin') && data['isAdmin'] == 'yes') {
                  return Row(
                    children: [
                      Appbarrepet(),
                      IconButton(
                        icon: Icon(Icons.analytics),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminDashboard()),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Appbarrepet();
                }
              }
              return CircularProgressIndicator();
            },
          ),
        ],
        title: Text(
          "Barber.tn",
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
    );
  }
}
