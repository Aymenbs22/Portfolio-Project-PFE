// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_is_not_empty, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/screens/editprofile.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/screens/myorders.dart';
import 'package:flutter_application_12/screens/appointementpage.dart';
import 'package:flutter_application_12/provider/cart.dart';
import 'package:flutter_application_12/widgets/testbuttomnavbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final CollectionReference ordersCollection =
    FirebaseFirestore.instance.collection('reservedproducts');

class Checkout extends StatefulWidget {
  @override
  State<Checkout> createState() => _ProductsState();
}

class _ProductsState extends State<Checkout> {
  bool showdetails = true;
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  String? selectedRegion;
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    // Instancee of class cart
    final classInstancee = Provider.of<Cart>(context);
    final User? user = FirebaseAuth.instance.currentUser;

    void _checkout() async {
      // the _checkout function first checks if the user not null 
      // it will get the user email and fetch all data from products selected
      // then will insert it into the database with the data info and the adress and user information
      if (user != null) {
        // Here we will get the email address of the user
        String userEmail = user.email ?? '';
        // Here we will fetch the data of the selectedproducts to insert it later into the collection
        List<Map<String, dynamic>> productsData =
            classInstancee.selectedproducts
                .map((product) => {
                      'name': product.name,
                      'price': product.price,
                      'imgPath': product.imgPath,
                    })
                .toList();

        // Here we will insert the products reserved into the database with the email that already get before
        await ordersCollection.add({
          'userEmail': userEmail,
          'timestamp': FieldValue.serverTimestamp(),
          'address': addressController.text,
          'city': selectedCity,
          'region': selectedRegion,
          'products': productsData,
          'totalPrice': classInstancee.totalprice,
          'status': "Pending",
        });
      }
      setState(() {
        // after we inset the new order we clear all products from
        // selectedproducts list and we put the total price to 0
        classInstancee.selectedproducts.clear();
        classInstancee.totalprice = 0;
      });
    }

    int _selectedIndex = 2;

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

    Future<void> _showAddressDialog() async {
      // here we have the dialog that will be visible when the user click checkout
      // this show dialog has the address text field and the region and
      // the city that is required to click confirm
      final _formKey = GlobalKey<FormState>();
      List<String> regions = [
        'Ariana',
        'Beja',
        'Ben Arous',
        'Bizerte',
        'Gabes',
        'Gafsa',
        'Jendouba',
        'Kairouan',
        'Kasserine',
        'Kebili',
        'Kef',
        'Mahdia',
        'Manouba',
        'Medenine',
        'Monastir',
        'Nabeul',
        'Sfax',
        'Sidi Bouzid',
        'Siliana',
        'Sousse',
        'Tataouine',
        'Tozeur',
        'Tunis',
        'Zaghouan'
      ];
      List<String> cities = ['Ben Arous', 'Rades', 'Mornag', 'Mourouj', 'Fouchana', 'Hammam-Lif', 'Ez Zahra', 'Mégrine', 'Khledia'];
      if (!classInstancee.selectedproducts.isEmpty) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Enter Your Informations',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 8),
                      TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an Address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedRegion,
                        decoration: InputDecoration(
                          labelText: 'Region',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: regions
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedRegion = newValue!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a region' : null,
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        items: cities
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCity = newValue!;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a city' : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // this Navigator pop will close the dialog when the user clicks confirm
                      Navigator.of(context).pop();
                      // and here we after the dialog pop we call the _checkout function 
                      _checkout();
                    }
                  },
                  child: Text('Confirm', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Cart is Empty',
          )),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        key: _formKey,
        body: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: 500,
                    child: ListView.builder(
                        // here we will display all products from the selectedproducts
                        // with the image and the name and finaly with the price and we have
                        // also a button to delete the item from the cart and we do all of that with the index of the product
                        padding: const EdgeInsets.all(20),
                        itemCount: classInstancee.selectedproducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              subtitle: Text(classInstancee
                                  .selectedproducts[index].price
                                  .toString()),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(classInstancee
                                    .selectedproducts[index].imgPath),
                              ),
                              title: Text(
                                  classInstancee.selectedproducts[index].name),
                              trailing: IconButton(
                                  onPressed: () {
                                    classInstancee.removeproduct(
                                        classInstancee.selectedproducts[index]);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[800],
                                  )),
                            ),
                          );
                        }),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: GoogleFonts.roboto(fontSize: 18.0),
                      ),
                      Text(
                        // here we will display the total price of products using
                        // totalprice from the instance that we do previously
                        '\$ ${classInstancee.totalprice}',
                        style: GoogleFonts.roboto(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 210,
                  height: 60,
                  child: ElevatedButton(
                    // here we call the _showAddressDialog that has all features in the cart system
                    onPressed: _showAddressDialog,
                    child: Text(
                      'Confirm Your Order',
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [],
          title: Text(
            "Checkout Page",
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
      ),
    );
  }
}
