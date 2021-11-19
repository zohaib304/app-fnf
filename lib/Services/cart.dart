import 'dart:developer';

import 'package:android_app_fnf/Models/cart_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  Future<void> addToCart(BuildContext context, String productId, String name,
      double price, String supplierId, String userId, String imageUrl) async {
    CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');
    DocumentReference cartDocRef = cartRef.doc(productId);

    // check if product already exists in cart
    DocumentSnapshot cartDocSnapshot = await cartDocRef.get();
    if (cartDocSnapshot.exists) {
      // product already exists in cart
      // update quantity
      int quantity = (cartDocSnapshot.data() as dynamic)['quantity'];
      await cartDocRef.update({
        'quantity': quantity + 1,
      }).then((value) => log('updated cart'));
    } else {
      // product does not exist in cart
      // add product to cart
      await cartDocRef.set({
        'productId': productId,
        "userId": userId,
        'name': name,
        'price': price,
        'quantity': 1,
        'supplierId': supplierId,
        'image': imageUrl,
      }).then((value) => log('added to cart'));
    }
  }

  // get cart items from firebase
  Stream<List<CartItem>> getCartItems(String userId) {
    final snapshots = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .snapshots();
    return snapshots.map(
      (snapshot) => (snapshot.docs.map(
        (snapshot) {
          final data = snapshot.data();
          return CartItem(
            productId: snapshot.id,
            name: data['name'],
            price: data["price"],
            quantity: data['quantity'],
            image: data['image'],
          );
        },
      ).toList()),
    );
  }

  Future<void> removeFromCart(String productId) async {
    CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');
    DocumentReference cartDocRef = cartRef.doc(productId);

    // check if product already exists in cart
    DocumentSnapshot cartDocSnapshot = await cartDocRef.get();
    if (cartDocSnapshot.exists) {
      // product already exists in cart
      // update quantity
      int quantity = (cartDocSnapshot.data() as dynamic)['quantity'];
      if (quantity > 1) {
        await cartDocRef.update({
          'quantity': quantity - 1,
        }).then((value) => log('updated cart'));
      } else {
        // remove product from cart
        await cartDocRef.delete().then((value) => log('removed from cart'));
      }
    }
  }

  // clear cart
  Future<void>? clearCart(String userId) async {
    CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');
    QuerySnapshot cartSnapshot =
        await cartRef.where('userId', isEqualTo: userId).get();
    if (cartSnapshot.docs.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      cartSnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }
  }

  // get total price of cart
  Stream<double> getTotalPrice(String userId) {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .snapshots();

    return cartRef.map(
      (snapshot) => snapshot.docs.fold(
        0.0,
        (previousValue, doc) {
          final data = doc.data();
          return previousValue + (data['price'] * data['quantity']);
        },
      ),
    );
  }

  // get total quantity of cart
  Stream<int> getTotalQuantity(String userId) {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .snapshots();

    return cartRef.map(
      (snapshot) => snapshot.docs.fold(
        0,
        (previousValue, doc) {
          final data = doc.data();
          log((data['quantity'] + previousValue).toString());
          int total = data['quantity'] + previousValue;
          return total;
        },
      ),
    );
  }
}
