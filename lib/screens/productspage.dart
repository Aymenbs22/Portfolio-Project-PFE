// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter_application_12/classes/itemclass.dart';
import 'package:flutter_application_12/provider/cart.dart';
import 'package:flutter_application_12/widgets/repeatedsnackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  Product product;

  Products({required this.product});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool showdetails = true;

  @override
  Widget build(BuildContext context) {
    // here we have the products page it is simple we just show the details of the products
    // the product name and the price and discription of it
    final classInstancee = Provider.of<Cart>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  color: Colors.blue[00],
                  elevation: 15,
                  margin: EdgeInsets.all(15),
                  child: Image.network(widget.product.imgPath)),
              SizedBox(
                height: 11,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "${widget.product.name}",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "\$ ${widget.product.price}",
                    style: GoogleFonts.roboto(fontSize: 20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "  Available in stock  ",
                          style: GoogleFonts.roboto(
                              fontSize: 15, color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 40, 212, 112),
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Product Info : ",
                    style: GoogleFonts.roboto(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  "${widget.product.information}",
                  style: GoogleFonts.roboto(fontSize: 16),
                  maxLines: showdetails ? 3 : null,
                  overflow: TextOverflow.fade,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      if (showdetails == true) {
                        showdetails = false;
                      } else {
                        showdetails = true;
                      }
                    });
                  },
                  child: showdetails ? Text("Show More") : Text("Show Less")),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  classInstancee.addproduct(widget.product);
                  snackbar(context, "Product Added to Cart");
                },
                icon: Icon(Icons.add_shopping_cart_rounded))
          ],
          title: Text(
            "Product Information",
            style: GoogleFonts.roboto(
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
