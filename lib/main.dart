import 'package:android_app_fnf/Models/order_by.dart';
import 'package:android_app_fnf/Pages/categories.dart';
import 'package:android_app_fnf/Pages/help.dart';
import 'package:android_app_fnf/Pages/manage_account.dart';
import 'package:android_app_fnf/Pages/new_address.dart';
import 'package:android_app_fnf/Pages/order_confirmed.dart';
import 'package:android_app_fnf/Pages/order_details.dart';
import 'package:android_app_fnf/Pages/product_details.dart';
import 'package:android_app_fnf/Pages/profile.dart';
import 'package:android_app_fnf/Pages/select_payament.dart';
import 'package:android_app_fnf/Pages/view_cart.dart';
import 'package:android_app_fnf/Pages/view_orders.dart';
import 'package:android_app_fnf/Services/add_new_address.dart';
import 'package:android_app_fnf/Services/auth.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:android_app_fnf/Services/order.dart';
import 'package:android_app_fnf/Services/products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

// local imports
import 'Pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderBy(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: const Color(0xffFF3E44),
        ),
        home: const Parent(),
        routes: {
          ProductDetails.routeName: (context) => const ProductDetails(),
          Profile.routeName: (context) => const Profile(),
          ViewCart.routeName: (context) => const ViewCart(),
          SelectPayment.routeName: (context) => const SelectPayment(),
          NewAddress.routeName: (context) => NewAddress(),
          OrderConfirmed.routeName: (context) => const OrderConfirmed(),
          Help.routeName: (context) => const Help(),
          OrderDetails.routeName: (context) => const OrderDetails(),
        },
      ),
    );
  }
}

class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  _ParentState createState() => _ParentState();
}

class _ParentState extends State<Parent> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Home(),
    const Categories(),
    const ViewOrders(),
    const Help(),
    const ManageAccount(),
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTapped,
        selectedItemColor: Theme.of(context).primaryColor,
        selectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline_rounded),
            activeIcon: Icon(Icons.help_rounded),
            label: 'Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Account',
          )
        ],
      ),
    );
  }
}
