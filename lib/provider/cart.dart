import 'package:flutter/material.dart';
import 'package:flutter_application_12/classes/itemclass.dart';

class Cart with ChangeNotifier {
  // here we have cart class to use it later in the home or the checkout page
  //to add products and delete products
  List selectedproducts = [];
  double totalprice = 0;

  addproduct(Product product) {
    selectedproducts.add(product);
    totalprice += product.price.round();
    notifyListeners();
  }

  removeproduct(Product product) {
    selectedproducts.remove(product);
    totalprice -= product.price.round();
    notifyListeners();
  }
}
