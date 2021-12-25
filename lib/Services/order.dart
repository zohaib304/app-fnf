import 'dart:developer';

import 'package:android_app_fnf/Models/place_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Order with ChangeNotifier {
  // write a function take userId, supplierId and list as argument and add the order to the firebase collection

  Future<void> addOrder(
    String userId,
    String customerName,
    String address,
    String city,
    String state,
    String zip,
    String phone,
    String cartId,
    String paymentMethod,
  ) async {
    log(cartId);
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(cartId)
        .get()
        .then((value) {
      log(value.data()!['productId']);
      log(paymentMethod);
      try {
        FirebaseFirestore.instance.collection('orders').doc().set({
          'userId': userId,
          'customerName': customerName,
          'address': address,
          'city': city,
          'state': state,
          'zip': zip,
          'phone': phone,
          'status': 'pending',
          'paymentMethod': paymentMethod,
          'productId': value.data()!['productId'],
          'productPrice': value.data()!['price'] * value.data()!['quantity'],
          'productName': value.data()!['name'],
          'quantity': value.data()!['quantity'],
          'supplierId': value.data()!['supplierId'],
          'image': value.data()!['image'],
          'date': DateTime.now(),
        }).then((value) => {
              log("Order Placed"),
              // clear cart after order is placed
              FirebaseFirestore.instance.collection('cart').doc(cartId).delete()
            });
      } on FirebaseException catch (e) {
        log(e.message.toString());
      }
    });
  }

  // write a function to get all the orders of a particular user and return a stream of the orders
  Stream<List<PlaceOrder>> getOrders(String userId) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        log(doc.id);
        return PlaceOrder(
          productId: doc.data()['productId'],
          productName: doc.data()['productName'],
          customerName: doc.data()['customerName'],
          productImage: doc.data()['image'],
          productPrice: doc.data()['productPrice'],
          productQuantity: doc.data()['quantity'],
          paymentMethod: doc.data()['paymentMethod'],
          status: doc.data()['status'],
        );
      }).toList();
    });
  }
}
