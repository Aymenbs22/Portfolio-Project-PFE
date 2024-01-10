// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/consts/colors.dart';
import 'package:flutter_application_12/main.dart';
import 'package:flutter_application_12/screens/forgotpass.dart';
import 'package:flutter_application_12/screens/signup.dart';
import 'package:flutter_application_12/provider/googlesignin.dart';
import 'package:flutter_application_12/widgets/repeatedsnackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loginloading = false;
  bool visible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  loginfunc() async {
    // Sign in a user with an email address and password using Firebase Authentication
    // and we check if the email not found or the password is wrong elese we return msg with snackbar
    if (mounted) {
      setState(() {
        loginloading = true;
      });
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (mounted) {
        snackbar(context, 'You have successfully logged in');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        if (mounted) {
          snackbar(context, 'No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        if (mounted) {
          snackbar(context, 'Wrong password provided for that user.');
        }
      } else {
        if (mounted) {
          snackbar(context, 'Please enter valid email or password.');
        }
      }
    }
    if (mounted) {
      setState(() {
        loginloading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // dispose to clear up the controller
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // here we have an instance of signInWithGoogle to use it later in google login
    final googlelogin = Provider.of<signInWithGoogle>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [],
          title: Text(
            "LOGIN",
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(33.0),
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[350],
                            radius: 80,
                            backgroundImage:
                                AssetImage("assets/img/barber.png"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(8),
                            suffixIcon: Icon(Icons.email),
                            hintText: "Enter Your Email : ")),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: !visible,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(8),
                            suffixIcon: IconButton(
                              icon: visible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                            ),
                            hintText: "Enter Your Password : ")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Forgotpassword()),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 15),
                            )),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await loginfunc();
                        if (!mounted) return;
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(colorgrey),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        ),
                        elevation: MaterialStateProperty.all(5),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100))),
                      ),
                      child: loginloading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300,
                      child: Row(
                        children: [
                          Expanded(
                              child: Divider(
                            height: 9,
                            thickness: 1,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          )),
                          Text("OR"),
                          Expanded(
                              child: Divider(
                            height: 9,
                            thickness: 1,
                            color: const Color.fromARGB(255, 7, 7, 7),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Sign in with"),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 44),
                      child: GestureDetector(
                        onTap: () async {
                          await googlelogin.googlelogin(() {
                            if (!mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.3)),
                              child: SvgPicture.asset(
                                "assets/img/newlogo.svg",
                                height: 21,
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signup()),
                                      );
                                    },
                                    child: Text('Sign Up',
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
