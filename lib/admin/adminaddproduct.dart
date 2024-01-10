// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPage createState() => _AddProductPage();
}

class _AddProductPage extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String _productTitle = '';
  String _productInformation = '';
  double _productPrice = 0.0;
  XFile? _imageFile;

  Widget _buildTitleField() {
    // function that check if the product title field is empty or null to validate that the user type the data
    // and when the user submit the form the value of _productTitle will set to the value that the user typed in this field
    // to insert it later in database
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Product Title', border: OutlineInputBorder()),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Product title is required';
          }
          return null;
        },
        onSaved: (String? value) {
          _productTitle = value!;
        },
      ),
    );
  }

  Widget _buildInformationField() {
    // function that check if the product Information field is empty or null to validate that the user typed the data
    // and when the user submit the form the value of _productInformation will be set to the value that the user typed in this field
    // to insert it later in database
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Product Description', border: OutlineInputBorder()),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Product Description is required';
          }
          return null;
        },
        onSaved: (String? value) {
          _productInformation = value!;
        },
      ),
    );
  }

  Widget _buildPriceField() {
    // function that check if the product price field is empty or null or is number to validate that the user typed the data
    // and when the user submit the form the value of _productPrice will set to the value that the user typed in this field
    // to insert it later in database
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration:
            InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Price is required';
          }
          if (double.tryParse(value) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
        onSaved: (String? value) {
          _productPrice = double.parse(value!);
        },
      ),
    );
  }

  Widget _buildImagePickerField() {
    // function that check if the admin select an image for the product or not if not it will display Please Select an Image.
    // if the user select an image using _pickImage function the the image selected will be displayed as Image.file in the page
    // to insert it later in database
    return Column(
      children: [
        _imageFile == null
            ? Column(
                children: [
                  Text(
                    'Please Select an Image.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                ],
              )
            : Image.file(File(_imageFile!.path)),
        SizedBox(
          width: 150,
          height: 60,
          child: ElevatedButton(
            onPressed: _pickImage,
            child: Text(
              'Pick Image',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
      ],
    );
  }

  Future<void> _pickImage() async {
    // function asynchronously retrieves an image from the user's gallery and assigns it to _imageFile.
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<String> _uploadImageToFirebase(XFile imageFile) async {
    // function that will change the name of the image to avoide repeated name of images then we upload the
    // image to the firebase storage and finally we get the url of the image to insert it later in the imgpath field
    String fileName = basename(imageFile.path);
    Random random = Random();
    int randomNumber = random.nextInt(879798789);
    fileName = "$randomNumber-$fileName";
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(imageFile.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _imageFile == null) {
      // this void function will check if the there is no image or the form fields have invalid data
      print('No image please select one !');
      return;
    }

    _formKey.currentState!.save();

    String imageUrl = await _uploadImageToFirebase(_imageFile!);

    // here if all the checks passed we insert the data of the new product to products collection
    CollectionReference products =
        FirebaseFirestore.instance.collection('products');
    try {
      await products.add({
        'name': _productTitle,
        'price': _productPrice,
        'imgPath': imageUrl,
        'information': _productInformation
      });
      print('Product Added');
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [],
        title: Text(
          "Add Products",
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
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildTitleField(),
                _buildInformationField(),
                _buildPriceField(),
                SizedBox(height: 15),
                _buildImagePickerField(),
                SizedBox(height: 15),
                SizedBox(
                  width: 150,
                  height: 60,
                  child: ElevatedButton(
                    child: Text(
                      'Add Product',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    onPressed: _submitForm,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
