import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Order with ChangeNotifier {
  // write a function take userId, supplierId and list as argument and add the order to the firebase collection

  Future<void> addOrder(
    String userId,
    String productId,
    String productName,
    String productPrice,
    String supplierId,
    String imageUrl,
    String customerName,
    String address,
    String city,
    String state,
    String zip,
    String phone,
  ) async {
    // create order collection
    final CollectionReference orderCollection =
        FirebaseFirestore.instance.collection('orders');

    try {
      orderCollection.add({
        'userId': userId,
        'productId': productId,
        'productName': productName,
        'productPrice': productPrice,
        'supplierId': supplierId,
        'imageUrl': imageUrl,
        'status': 'pending',
        'customerName': customerName,
        'address': address,
        'city': city,
        'state': state,
        'zip': zip,
        'phone': phone,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) => log("Order Place Successfully"));
    } on FirebaseException catch (e) {
      log(e.message.toString());
    }
  }
}
