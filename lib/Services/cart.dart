import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  Future<void> addToCart(BuildContext context, String productId, String name,
      double price, String supplierId, String userId) async {
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
        "userId": userId,
        'name': name,
        'price': price,
        'quantity': 1,
        'supplierId': supplierId,
      }).then((value) => log('added to cart'));
    }
    // cartDocRef.set({
    //   'productId': productId,
    //   'name': name,
    //   'price': price,
    //   'supplierId': supplierId,
    //   'quantity': 1,
    // }).then((value) => log('Cart added'));
  }
}
