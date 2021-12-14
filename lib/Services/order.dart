import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Order with ChangeNotifier {
  // write a function take userId, supplierId and list as argument and add the order to the firebase collection

  Future<void> addOrder(
    String customerName,
    String address,
    String city,
    String state,
    String zip,
    String phone,
    String cartId,
    String paymentMethod,
  ) async {
    // log(cartId);
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .get()
        .then((value) {
      log(value.data().toString());
      try {
        FirebaseFirestore.instance.collection('orders').doc().set({
          'cartId': value.id,
          'customerName': customerName,
          'address': address,
          'city': city,
          'state': state,
          'zip': zip,
          'phone': phone,
          'status': 'pending',
          'paymentMethod': paymentMethod,
          'productPrice': value.data()!['price'] * value.data()!['quantity'],
          'productName': value.data()!['name'],
          'quantity': value.data()!['quantity'],
          'supplierId': value.data()!['supplierId'],
          'image': value.data()!['image'],
        }).then((value) => {
              // clear cart after order is placed
              FirebaseFirestore.instance.collection('cart').doc(cartId).delete()
            });
      } on FirebaseException catch (e) {
        log(e.message.toString());
      }
    });
  }
}
