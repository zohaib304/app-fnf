import 'dart:developer';

import 'package:android_app_fnf/Models/cart_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Cart with ChangeNotifier {
  // list of cart items doc id
  List<String> _cartIds = [];
  // list of cart items
  List<CartItem> _cartItems = [];
  // get cart items
  List<CartItem> get cartItems {
    return [..._cartItems];
  }

  // get list of doc id of cart items
  List<String> get cartIds {
    return [..._cartIds];
  }

  // get list of doc id of cart items from firestore collection where userId equal to userId
  Future<void> getDocIds(String userId) async {
    log('getDocIds');
    // final userId = await getUserId();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();
    _cartIds = querySnapshot.docs.map<String>((doc) => doc.id).toList();
    notifyListeners();
  }

  // // add to cart and allow only one item in cart for each user id firebase collection
  // Future<void> addToCart(String productId, String name, double price,
  //     String supplierId, String userId, String imageUrl) async {
  //   log('addToCart');
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('cart')
  //       .where('userId', isEqualTo: userId)
  //       .get();
  //   if (querySnapshot.docs.isEmpty) {
  //     await FirebaseFirestore.instance.collection('cart').doc("cartId").set({
  //       'userId': userId,
  //       'productId': productId,
  //       'name': name,
  //       'price': price,
  //       'image': imageUrl,
  //       'quantity': 1,
  //       'supplierId': supplierId,
  //     });
  //   }
  //   notifyListeners();
  // }

  Future<void> addToCart(String productId, String name, double price,
      String supplierId, String userId, String imageUrl) async {
    CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');
    DocumentReference cartDocRef = cartRef.doc();

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
        'cartId': cartDocRef.id,
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

  // check if product already exists for current user in cart and return stream true or false accordingly
  Stream<bool> checkIfProductExists(String productId, String userId) {
    final snapshots = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .snapshots();
    return snapshots.map(
      (snapshot) => snapshot.docs
          .map(
            (snapshot) {
              final data = snapshot.data();
              return data['productId'] == productId;
            },
          )
          .toList()
          .contains(true),
    );
  }

  // increase quantity of product in cart
  Future<void> increaseQuantity(String productId) async {
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
    }
  }

  // delete product from cart
  Future<void> deleteFromCart(String productId) async {
    CollectionReference cartRef = FirebaseFirestore.instance.collection('cart');
    DocumentReference cartDocRef = cartRef.doc(productId);

    // check if product already exists in cart
    DocumentSnapshot cartDocSnapshot = await cartDocRef.get();
    if (cartDocSnapshot.exists) {
      // product already exists in cart
      // remove product from cart
      await cartDocRef.delete().then((value) => log('removed from cart'));
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
          int total = 0;
          total = data['quantity'] + previousValue;
          return total;
        },
      ),
    );
  }

  // check if cart is empty
  Stream<bool> isCartEmpty(String userId) {
    final cartRef = FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .snapshots();

    return cartRef.map(
      (snapshot) => snapshot.docs.isEmpty,
    );
  }
}
