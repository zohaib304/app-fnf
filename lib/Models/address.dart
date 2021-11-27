import 'package:flutter/material.dart';

class ShippingAddress with ChangeNotifier {
  String id;
  String customerName;
  String address;
  String city;
  String state;
  String zipCode;
  String phone;
  String userId;

  ShippingAddress({
    required this.id,
    required this.customerName,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phone,
    required this.userId,
  });
}
