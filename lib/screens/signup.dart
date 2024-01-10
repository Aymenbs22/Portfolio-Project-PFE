// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/consts/colors.dart';
import 'package:flutter_application_12/screens/login.dart';
import 'package:flutter_application_12/widgets/repeatedsnackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'dart:io';

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool registerloading = false;
  bool visible = true;
  final _formKey = GlobalKey<FormState>();
  File? imgPath;
  String? imageName;

  cameraimg() async {
    // function that Retrieves an image from the camera and stores the path of it to imagePath
    // we change the name of every image to a random name to avoid repeated names this may do some problems
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (img != null) {
        setState(() {
          imgPath = File(img.path);
          imageName = basename(img.path);
          Random random = Random();
          int randomNumber = random.nextInt(879798789);
          imageName = "$randomNumber-$imageName";
        });
      } else {
        snackbar(context, "No image picked please select one !");
      }
    } catch (error) {
      snackbar(context, "$error");
    }
  }

  galleryimg() async {
    // function that Retrieves an image from the gallery and stores the path of it to imagePath
    // we change the name of every image to a random name to avoid repeated names this may do some problems
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (img != null) {
        setState(() {
          imgPath = File(img.path);
          imageName = basename(img.path);
          Random random = Random();
          int randomNumber = random.nextInt(879798789);
          imageName = "$randomNumber-$imageName";
        });
      } else {
        snackbar(context, "No image please select one !");
      }
    } catch (error) {
      snackbar(context, "$error");
    }
  }

  signup() async {
    // here we have the signup function using firebase and fireauth first we create the account using createUserWithEmailAndPassword
    // then we upload the image in FirebaseStorage and also we insert the image link and the username and the email in the firestore db
    // to use it later in orders and appointements
    setState(() {
      registerloading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final storageRef = FirebaseStorage.instance.ref(imageName);
      await storageRef.putFile(imgPath!);
      String imageurl = await storageRef.getDownloadURL();

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      users
          .doc(credential.user!.uid)
          .set({
            'username': usernameController.text,
            'email': emailController.text,
            'imagelink': imageurl
          })
          .then((value) =>
              snackbar(context, "Your account has been successfully created."))
          .catchError((error) => print('$error'));
      snackbar(context, 'Your account has been successfully created.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackbar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        snackbar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      registerloading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "REGISTER",
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
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: Stack(
                        children: [
                          imgPath == null
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey[350],
                                  radius: 80,
                                  backgroundImage:
                                      AssetImage("assets/img/barber.png"),
                                )
                              : ClipOval(
                                  child: Image.file(
                                  imgPath!,
                                  height: 160,
                                  width: 160,
                                  fit: BoxFit.cover,
                                )),
                          Positioned(
                              right: -14,
                              bottom: -15,
                              child: IconButton(
                                  onPressed: () {
                                    galleryimg();
                                  },
                                  icon: Icon(Icons.image))),
                          Positioned(
                              left: -14,
                              bottom: -15,
                              child: IconButton(
                                  onPressed: () {
                                    cameraimg();
                                  },
                                  icon: Icon(Icons.photo_camera)))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: usernameController,
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
                            hintText: "Enter Your Username : ",
                            suffixIcon: Icon(Icons.person))),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        validator: (value) {
                          // here we make a validator using regular expression to
                          // check if the email to make sure is a valid email format
                          return value!.contains(RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"))
                              ? null
                              : "Please enter a valid Email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    TextFormField(
                        validator: (value) {
                          // here we make a validator using regular expression to
                          // check if the password to make sure is a valid password format
                          return value!.contains(RegExp(
                                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d\W]).{8,100}$"))
                              ? null
                              : "Your password must include the following:\n\n  8-100 Characters \n  Upper and lower case characters\n  At least one Number or special characters";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: visible ? true : false,
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
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            imgPath != null &&
                            imageName != null) {
                          await signup();
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        } else {
                          snackbar(
                              context, "Something went wrong please try again");
                        }
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
                      child: registerloading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Register",
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text('Sign In',
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        )
                      ],
                    )
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
