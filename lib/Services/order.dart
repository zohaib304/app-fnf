import 'dart:developer';

import 'package:android_app_fnf/Models/cart_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order with ChangeNotifier {
  // write a function take userId, supplierId and list as argument and add the order to the firebase collection

  Future<void> addOrder(
    String userId,
    List<String> cartItems,
    String customerName,
    String address,
    String city,
    String state,
    String zip,
    String phone,
  ) async {
    List<Map<String, dynamic>> orderItems = [];
    // create order collection
    final CollectionReference orderCollection =
        FirebaseFirestore.instance.collection('orders');
    // create order document
    final DocumentReference orderDocument = orderCollection.doc();
    // create order id
    final String orderId = orderDocument.id;

    try {
      orderCollection.add({
        'orderId': orderId,
        'userId': userId,
        'cartItems': cartItems,
        'status': 'pending',
        'timestramp': DateTime.now().toIso8601String(),
        'customerName': customerName,
        'address': address,
        'city': city,
        'state': state,
        'zip': zip,
        'phone': phone,
      }).then((value) => log("Order Place Successfully"));
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }
}
