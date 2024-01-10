// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/consts/colors.dart';
import 'package:flutter_application_12/admin/admindashboard.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/widgets/repeatedsnackbar.dart';
import 'dart:async';

class VerifyAccountPage extends StatefulWidget {
  VerifyAccountPage({super.key});

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  bool isVerified = false;
  bool ResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    // init state first run when we go to this page 
    super.initState();
    // set isVerified condition to true or false depending on FirebaseAuth emailVerified
    // this for the new user login the existing and verified account check if admin or not bellow
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      // here if the email is not verified we sent an email of verification using sendEmailVerification function
      // sendEmailVerification();

      // this well reload every 5 seconds untill the the email is verified
      timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();

        setState(() {
          // this will set the isVerified to true because the email is verified
          isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        });

        if (isVerified) {
          timer.cancel();
          checkStatus();
        }
      });
    }
  }

  void checkStatus() async {
    // this function to check the status of the user who logged in if he has a
    // field called isAdmin and the value of it yes
    // it takes the user to the admin dashboard if not it takes the user to the home page
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      // here we Check if the document exists and has data.
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        // here we check the is admin field if yes it takes the user to the admin dashboard
        if (userData.containsKey('isAdmin') && userData['isAdmin'] == 'yes') {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      } else {
        // This to avoid error of no document called isAdmin because in default the user has not the isAdmin field
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    }
  }

  sendEmailVerification() async {
    try {
      // await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        ResendEmail = false;
      });
      // this deleay to avoid the block from fireauth because
      // whenn we spam the resend verification email button we get device block
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        ResendEmail = true;
      });
    } catch (e) {
      snackbar(context, "$e");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVerified) {
      // here if the is isVerified is false we get the Verification Page
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [],
          title: Text(
            "Verification Page",
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verify you email address!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              Text(
                "A verification email has been sent to your email \n Please Verify your email to start Shopping and Make your appointment",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: ResendEmail ? sendEmailVerification : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(colorgrey),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
                ),
                child: Text(
                  "Resend Email",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
              SizedBox(height: 11),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // here we fetch the users collection and we check if the user is an admin we go to admin page else we go to home page
      return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error fetching user data')),
              );
            }
            if (snapshot.hasData && snapshot.data?.data() != null) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              if (userData['isAdmin'] == 'yes') {
                return AdminDashboard();
              } else {
                return Home();
              }
            } else {
              return Scaffold(
                body: Home(),
              );
            }
          }
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      );
    }
  }
}
