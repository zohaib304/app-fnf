import 'package:android_app_fnf/Models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {

  // get all products from firebase database and store it in a list
  Stream<List<Product>> getProducts() {
    final collectionReference =
        FirebaseFirestore.instance.collection('products');
    final snapshots = collectionReference.snapshots();

    return snapshots.map(
      (snapshot) => (snapshot.docs.map(
        (snapshot) {
          final data = snapshot.data();
          return Product(
            id: snapshot.id,
            name: data["productName"],
            price: double.parse(data["price"]),
            description: data['productDescription'],
            supplierId: data['supplier_id'],
            images: data['image'] as List<dynamic>,
          );
        },
      ).toList()),
    );
  }

  // get product by id
  Stream<Product> getProductById(docId) {
    final documentReference =
        FirebaseFirestore.instance.collection('products').doc(docId);
    final snapshots = documentReference.snapshots();

    return snapshots.map(
      (snapshot) => Product(
        id: snapshot.id,
        name: snapshot.data()!["productName"],
        price: double.parse(snapshot.data()!["price"]),
        description: snapshot.data()!['productDescription'],
        supplierId: snapshot.data()!['supplier_id'],
        images: snapshot.data()!['image'] as List<dynamic>,
      ),
    );
  }
}