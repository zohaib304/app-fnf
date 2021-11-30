import 'package:android_app_fnf/Models/place_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Order with ChangeNotifier {
  // write a function take userId, supplierId and list as argument and add the order to the firebase collection

  Future<void> addOrder(
      String userId, List<String> cartItems) async {
    // create order collection
    final CollectionReference orderCollection =
        FirebaseFirestore.instance.collection('orders');
    // create order document
    final DocumentReference orderDocument = orderCollection.doc();
    // create order id
    final String orderId = orderDocument.id;
    // create order
    orderCollection.add({
      'orderId': orderId,
      'userId': userId,
      'cartItems': cartItems,
      'status': 'pending',
      'timestramp': DateTime.now().toIso8601String(),
    });
  }
}
