// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, library_private_types_in_public_api, sort_child_properties_last, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_12/screens/checkout.dart';
import 'package:flutter_application_12/screens/editprofile.dart';
import 'package:flutter_application_12/screens/home.dart';
import 'package:flutter_application_12/screens/myorders.dart';
import 'package:flutter_application_12/widgets/testbuttomnavbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Make an Appointment',
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  User? user = FirebaseAuth.instance.currentUser;

  Stream<List<String>> getProducts() {
    // function to get the haircuts from the firestore in real time using stream
    return FirebaseFirestore.instance
        .collection('haircuts')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc['haircutsName'].toString())
          .toList();
    });
  }

  String selectedProduct = 'Buzz cut';

  Stream<List<String>> getType() {
    // function to get the type of service of shaving from the
    // firestore in real time using stream and return them as a list
    return FirebaseFirestore.instance
        .collection('typeofservice')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['Type'].toString()).toList();
    });
  }

  String selectedType = 'Hair and Beard';

  Future<void> selectDate(BuildContext context) async {
    // function that Open showDatePicker to select the date of
    // the appointement to update pickeddate with the user selected date
    final DateTime? pickeddate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (pickeddate != null && pickeddate != selectedDate) {
      setState(() {
        selectedDate = pickeddate;
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    // function that Open showTimePicker to select the time of
    // the appointement to update pickeddate with the user selected date
    final TimeOfDay? pickedtime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedtime != null && pickedtime != selectedTime) {
      setState(() {
        selectedTime = pickedtime;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Here we will get the data from the form using controllers
      String name = nameController.text;
      int phonenumber = int.parse(phonenumberController.text);
      String description = descriptionController.text;

      // Here we will Combine the date and time to
      // formated it later to insert it to the database in a good way
      DateTime dateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      // formated it to insert it to the database in a good way
      // this will give us the time like this 22:00 and the date like this 12/27/2023
      String formattedTime = DateFormat.Hm().format(dateTime);
      String formattedDate = DateFormat.yMd().format(dateTime);

      // Now we will insert the date into the appointment collection
      await FirebaseFirestore.instance.collection('appointment').add({
        'name': name,
        'PhoneNumber': phonenumber,
        'Email': user!.email,
        'description': description,
        'time': formattedTime,
        'date': formattedDate,
        'selectedProduct': selectedProduct,
        'selectedType': selectedType,
      });

      // snackbar to tell the user that the appointment was successfully created
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Your appointment has been set successfully, please come on time!')),
      );
    }
  }

  int _selectedIndex = 1;

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
          title: Text(
            "Make An Appointment",
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              //Form of the appointment with a controllers and simple check if the input is empty or not
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Name', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: phonenumberController,
                    decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<List<String>>(
                    // Here we have all the type of the shaving that we get from the collection typeofservice
                    stream: getType(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No data available');
                      }

                      return DropdownButtonFormField<String>(
                        // when the user select a type of service we use onChange to
                        // change the value of the selectedType to the value of the user selection
                        value: selectedType,
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                        items: (snapshot.data as List<String>).map((product) {
                          // here we display all the type of service from the snapshot data that we fetch previously
                          return DropdownMenuItem<String>(
                            value: product,
                            child: Text(product),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                            labelText: 'Type', border: OutlineInputBorder()),
                        validator: (value) {
                          // simple check if the value is empty or not
                          if (value == null || value.isEmpty) {
                            return 'Please select a product';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<List<String>>(
                    // Here we have all the haircuts styles that we get from the collection haircuts
                    stream: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No data available');
                      }

                      return DropdownButtonFormField<String>(
                        // when the user select a hair cut style we use onChange to
                        // change the value of the selectedProduct to the value of the user selection
                        value: selectedProduct,
                        onChanged: (value) {
                          setState(() {
                            selectedProduct = value!;
                          });
                        },
                        items: (snapshot.data as List<String>).map((product) {
                          // display all the products from the snapshot data that we fetch previously
                          return DropdownMenuItem<String>(
                            value: product,
                            child: Text(product),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                            labelText: 'Hair cut style',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          // check if the value is empty or not
                          if (value == null || value.isEmpty) {
                            return 'Please select a product';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Leave a note (optional)',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => selectDate(context),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "${selectedDate.toLocal()}".split(' ')[0],
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.calendar_month, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () => selectTime(context),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                selectedTime.format(context),
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.access_time, color: Colors.grey),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: SizedBox(
                      width: 210,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(
                          'Confirm The Appointement',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
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
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ],
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
