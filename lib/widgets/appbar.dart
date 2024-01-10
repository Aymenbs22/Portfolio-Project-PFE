// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_12/screens/checkout.dart';
import 'package:flutter_application_12/provider/cart.dart';
import 'package:provider/provider.dart';

class Appbarrepet extends StatelessWidget {
  const Appbarrepet({super.key});

  @override
  Widget build(BuildContext context) {
    final classInstancee = Provider.of<Cart>(context);
    return Row(
      children: [
        Stack(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Checkout(),
                    ),
                  );
                },
                icon: Icon(Icons.shopping_cart, color: Colors.black)),
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 87, 87, 87),
                  shape: BoxShape.circle),
              child: Text("${classInstancee.selectedproducts.length}",
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 13)),
            )
          ],
        ),
      ],
    );
  }
}
