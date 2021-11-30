import 'package:android_app_fnf/Models/address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddNewAddress with ChangeNotifier {
  // add address to firestore collection
  Future<void> addAddress(String customerName, String address, String city,
      String state, String zip, String phone, String userId) async {
    final addressCollection =
        FirebaseFirestore.instance.collection('addresses').doc();
    await addressCollection.set({
      'id': addressCollection.id,
      'customerName': customerName,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
      'userId': userId,
    });
    notifyListeners();
  }

  // get all addresses from firestore collection for a specific user id and return Stream list
  Stream<List<ShippingAddress>> getAddress(String userId) {
    final addressCollection =
        FirebaseFirestore.instance.collection('addresses');
    final snapshots =
        addressCollection.where('userId', isEqualTo: userId).snapshots();

    return snapshots.map(
      (snapshot) => (snapshot.docs.map(
        (snapshot) {
          final data = snapshot.data();
          return ShippingAddress(
            id: data['id'],
            userId: userId,
            customerName: data["customerName"],
            address: data["address"],
            city: data['city'],
            state: data['state'],
            zipCode: data['zip'],
            phone: data['phone'],
          );
        },
      ).toList()),
    );
  }

  // get address by id
  Future<ShippingAddress> getAddressById(String id) async {
    final addressCollection =
        FirebaseFirestore.instance.collection('addresses');
    final snapshot = await addressCollection.doc(id).get();
    final data = snapshot.data();
    return ShippingAddress(
      id: data!['id'],
      userId: data['userId'],
      customerName: data["customerName"],
      address: data["address"],
      city: data['city'],
      state: data['state'],
      zipCode: data['zip'],
      phone: data['phone'],
    );
  }

  // update address by id
  Future<void> updateAddress(String id, String customerName, String address,
      String city, String state, String zip, String phone) async {
    final addressCollection =
        FirebaseFirestore.instance.collection('addresses');
    await addressCollection.doc(id).update({
      'customerName': customerName,
      'address': address,
      'city': city,
      'state': state,
      'zip': zip,
      'phone': phone,
    });
    notifyListeners();
  }

  // delete single address from firestore collection
  Future<void> deleteAddress(String addressId) async {
    final CollectionReference addressCollection =
        FirebaseFirestore.instance.collection('addresses');
    await addressCollection.doc(addressId).delete();
    notifyListeners();
  }
}
