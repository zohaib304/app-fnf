class Product {
  final String id;
  final String name;
  final String description;
  final String supplierId;
  final double price;
  final List<dynamic> images;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.supplierId,
    required this.price,
    required this.images,
    this.isFavorite = false,
  });
}
