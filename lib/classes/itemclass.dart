// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Product {
  String name;
  double price;
  String imgPath;
  String information;

  Product(
      {required this.name,
      required this.price,
      required this.imgPath,
      required this.information});

  factory Product.fromMap(Map<String, dynamic> map) {
    // Constructs a Product object from a map containing name price imgPath and information
    return Product(
      name: map['name'] as String,
      price: map['price'] as double,
      imgPath: map['imgPath'] as String,
      information: map['information'] as String,
    );
  }
}

Future<List<Product>> getProductsFromDatabase() async {
  // Get all the products from the database and return a list of Product objects each object contain the product details
  await Firebase.initializeApp();
  var productsCollection = FirebaseFirestore.instance.collection('products');
  var querySnapshot = await productsCollection.get();
  List<Product> products = querySnapshot.docs.map((doc) {
    return Product.fromMap(doc.data());
  }).toList();
  return products;
}
