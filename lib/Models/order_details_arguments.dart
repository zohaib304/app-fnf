class OrderDetailsArguments {
  final String productId;
  final String name;
  final double price;
  final String supplierId;
  final String imageUrl;
  final String address;
  final String city;
  final String state;
  final String phone;
  final int quantity;
  final String paymentMethod;

  OrderDetailsArguments(
    this.productId,
    this.name,
    this.price,
    this.supplierId,
    this.imageUrl,
    this.address,
    this.city,
    this.state,
    this.phone,
    this.quantity,
    this.paymentMethod,
  );
}
