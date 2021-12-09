import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String image;
  final String supplierId;

  CartItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.image,
    required this.supplierId,
  });
}
