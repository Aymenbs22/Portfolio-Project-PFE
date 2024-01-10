// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/admin/adminaddproduct.dart';
import 'package:flutter_application_12/admin/adminremoveproduct.dart';
import 'package:flutter_application_12/admin/admineditproducts.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/admin/adminreservedproducts.dart';
import 'package:flutter_application_12/admin/adminappointements.dart';
import 'package:flutter_application_12/screens/login.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Admin Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  // here we have a simple admin dashboard takes the admin to 6 pages
  // we have navigate to home page / appointements page / reserved products / add products / edit products / remove products
  // we also have logout icon button in the navbar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }).catchError((error) {});
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(
          "Admin Dashboard",
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _CategoryCard(
              title: 'Home Page',
              icon: Icons.home,
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              ),
            ),
            _CategoryCard(
              title: 'Appointments',
              icon: Icons.calendar_today,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminAppointements()),
              ),
            ),
            _CategoryCard(
              title: 'Reserved Products',
              icon: Icons.shopping_cart,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminOrdersPage()),
              ),
            ),
            _CategoryCard(
              title: 'Add Products',
              icon: Icons.add,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              ),
            ),
            _CategoryCard(
              title: 'Edit Products',
              icon: Icons.edit,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminEditProductPage()),
              ),
            ),
            _CategoryCard(
              title: 'Remove Products',
              icon: Icons.delete,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductRemovePage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard(
      {required this.title, required this.icon, required this.onTap})
      : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 50, color: Theme.of(context).primaryColor),
              Text(title, style: GoogleFonts.roboto(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
