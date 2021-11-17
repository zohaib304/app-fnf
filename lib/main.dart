import 'package:android_app_fnf/Pages/product_details.dart';
import 'package:android_app_fnf/Services/auth.dart';
import 'package:android_app_fnf/Services/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// local imports
import "./Pages/error.dart";
import 'Pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
            create: (context) => context.read<Auth>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        routes: {
          ProductDetails.routeName: (context) => const ProductDetails(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return const Error();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const Home();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
