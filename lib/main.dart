// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_12/screens/login.dart';
import 'package:flutter_application_12/screens/verifyaccount.dart';
import 'package:flutter_application_12/provider/cart.dart';
import 'package:flutter_application_12/provider/googlesignin.dart';
import 'package:flutter_application_12/widgets/repeatedsnackbar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (context) {
          return signInWithGoogle();
        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BARBER.TN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
          // here we use streamBuilder that stream the authStateChanges to check
          // if the snapshot has data if it is true we go to the VerifyAccountPage
          // that has the function to take us to admin dashboard or the home page .....
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return snackbar(context, "Something went wrong");
            } else if (snapshot.hasData) {
              return VerifyAccountPage();
            } else {
              return Login();
            }
          },
        ),
      ),
    );
  }
}
