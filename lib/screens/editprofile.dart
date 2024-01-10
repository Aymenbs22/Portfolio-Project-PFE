// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, sort_child_properties_last

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_12/screens/checkout.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/screens/login.dart';
import 'package:flutter_application_12/screens/myorders.dart';
import 'package:flutter_application_12/screens/appointementpage.dart';
import 'package:flutter_application_12/widgets/firestore.dart';
import 'package:flutter_application_12/widgets/testbuttomnavbar.dart';
import 'package:flutter_application_12/widgets/userimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edit Profile Page',
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final emailController = TextEditingController();
  File? imagePath;
  String? imageName;
  final _formKey = GlobalKey<FormState>();

  cameraimg() async {
    // function that Retrieves an image from the camera and stores the path of it to imagePath
    // we change the name of every image to a random name to avoid repeated names this may do some problems
    final img = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (img != null) {
        setState(() {
          imagePath = File(img.path);
          imageName = basename(img.path);
          Random random = Random();
          int randomNumber = random.nextInt(879798789);
          imageName = "$randomNumber-$imageName";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No Image was taken please take new image')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$error")),
      );
    }
  }

  galleryimg() async {
    // function that Retrieves an image from the gallery and stores the path of it to imagePath
    // we change the name of every image to a random name to avoid repeated names this may do some problems
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      if (img != null) {
        setState(() {
          imagePath = File(img.path);
          imageName = basename(img.path);
          Random random = Random();
          int randomNumber = random.nextInt(879798789);
          imageName = "$randomNumber-$imageName";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image selected please select new image')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$error")),
      );
    }
  }

  void _PasswordDialog(BuildContext context) {
    // this function return a dialog that when the user type the new password and also check if the password is empty or not
    // if not we call changePassword with the password that user typed i need to add validation for the new password
    final _formKey = GlobalKey<FormState>();
    String _newPassword = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Form(
            key: _formKey,
            child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'New Password'),
                onChanged: (value) => _newPassword = value,
                validator: (value) {
                  // here we make a validator using regular expression to
                  // check if the password to make sure is a valid password format
                  return value!.contains(RegExp(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[\d\W]).{8,100}$"))
                      ? null
                      : "Please enter a valid password";
                }),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Change'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  _changePassword(context, _newPassword);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword(BuildContext context, String newPassword) async {
    // here we have the function from fireauth to change the current password of the user with the new password
    // if the try works fine we have a popup with snackbar to Password updated successfully if not we have the error message
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      print("Done");
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  int _selectedIndex = 4;

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [],
          title: Text(
            "Edit Your Profile",
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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                        child: Stack(
                          children: [
                            // here we have a condition to check if the image path == null
                            // thats will give us the image from FirestoreImage that get it from the database
                            // otherwise will give us the image was just changed by the user
                            imagePath == null
                                ? FirestoreImage(
                                    // give us the image of the user using the user id
                                    documentId: credential!.uid,
                                  )
                                : ClipOval(
                                    // give us the new image selected by the user using imagePath
                                    child: Image.file(
                                    imagePath!,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  )),
                            Positioned(
                                right: -14,
                                bottom: -15,
                                child: IconButton(
                                    onPressed: () async {
                                      await galleryimg();
                                      // here if the user change the image this will store the new image in the storage
                                      // and then we get the url of the new image from the storage and we change the field imagelink in the user collection
                                      // thats will change the image of the user
                                      if (imagePath != null) {
                                        final storageRef = FirebaseStorage
                                            .instance
                                            .ref(imageName);
                                        await storageRef.putFile(imagePath!);
                                        String imageurl =
                                            await storageRef.getDownloadURL();
                                        users
                                            .doc(credential!.uid)
                                            .update({'imagelink': imageurl});
                                      }
                                    },
                                    icon: Icon(Icons.image))),
                            Positioned(
                                left: -14,
                                bottom: -15,
                                child: IconButton(
                                    onPressed: () async {
                                      await cameraimg();
                                      // here if the user change the image this will store the new image in the storage
                                      // and then we get the url of the new image from the storage and we change the field imagelink in the user collection
                                      // thats will change the image of the user
                                      if (imagePath != null) {
                                        final storageRef = FirebaseStorage
                                            .instance
                                            .ref(imageName);
                                        await storageRef.putFile(imagePath!);
                                        String imageurl =
                                            await storageRef.getDownloadURL();
                                        users
                                            .doc(credential!.uid)
                                            .update({'imagelink': imageurl});
                                      }
                                    },
                                    icon: Icon(Icons.photo_camera)))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: Text('Account Details',
                            style: GoogleFonts.roboto(
                                fontSize: 24, fontWeight: FontWeight.bold))),
                    Divider(height: 20, thickness: 1),
                    GetUserName(
                      // here we call GetUserName that will give us data from the firebase
                      // this only need the user id to Read Data
                      documentId: credential!.uid,
                      textStyle: GoogleFonts.roboto(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // here we have the email and the created at that we get it from the fireauth
                        Text(
                          'Email: ${credential!.email.toString()}',
                          style: GoogleFonts.roboto(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Created date: ${credential!.metadata.creationTime.toString().substring(0, 10)}',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 50,
                        child: ElevatedButton(
                          // here we call the password dialog that open a dialog for the user to make new password
                          onPressed: () => _PasswordDialog(context),
                          child: Text('Change Password'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            label: Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            ),
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // here we have delete account was prebuilt from fireauth
                              // and also we delete the data of the user from the firestore db
                              // and finaly we make a pop to get push the user to the login page
                              credential!.delete();
                              users.doc(credential!.uid).delete();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()),
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }
}
