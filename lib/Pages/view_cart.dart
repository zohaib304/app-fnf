import 'dart:developer';

import 'package:android_app_fnf/Models/cart_items.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewCart extends StatelessWidget {
  const ViewCart({Key? key}) : super(key: key);

  static const routeName = '/view-cart';

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final getCartItems = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // clear cart button
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                child: const Text(
                  'Clear Cart',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  getCartItems.clearCart(firebaseUser!.uid);
                },
              ),
            ),
            // total quantity of items in cart
            StreamBuilder<int>(
              stream: getCartItems.getTotalQuantity(firebaseUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Total Items: ${snapshot.data}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text(
                  'Total Items: 0',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            StreamBuilder<List<CartItem>>(
              stream: getCartItems.getCartItems(firebaseUser.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final cartItems = snapshot.data;
                  if (cartItems!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No items in cart',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return ListTile(
                        title: Text(cartItem.name),
                        subtitle: Text(cartItem.price.toString() +
                            '    -    Qty ' +
                            cartItem.quantity.toString()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            getCartItems.removeFromCart(cartItem.productId);
                          },
                        ),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xffF5F6F8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: (Colors.grey[300])!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              StreamBuilder(
                stream: getCartItems.getTotalPrice(firebaseUser.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    elevation: 0,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: const Text("CHECKOUT"),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
