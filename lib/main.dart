import 'package:android_app_fnf/Pages/new_address.dart';
import 'package:android_app_fnf/Pages/order_confirmed.dart';
import 'package:android_app_fnf/Pages/product_details.dart';
import 'package:android_app_fnf/Pages/profile.dart';
import 'package:android_app_fnf/Pages/select_payament.dart';
import 'package:android_app_fnf/Pages/view_cart.dart';
import 'package:android_app_fnf/Services/add_new_address.dart';
import 'package:android_app_fnf/Services/auth.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:android_app_fnf/Services/order.dart';
import 'package:android_app_fnf/Services/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// local imports
import 'Pages/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        StreamProvider<User?>(
            create: (context) => context.read<Auth>().authStateChanges,
            initialData: null),
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddNewAddress(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xffFF3E44),
        ),
        home: const Home(),
        routes: {
          ProductDetails.routeName: (context) => const ProductDetails(),
          Profile.routeName: (context) => const Profile(),
          ViewCart.routeName: (context) => const ViewCart(),
          SelectPayment.routeName: (context) => const SelectPayment(),
          NewAddress.routeName: (context) => NewAddress(),
          OrderConfirmed.routeName: (context) => const OrderConfirmed(),
        },
      ),
    );
  }
}
