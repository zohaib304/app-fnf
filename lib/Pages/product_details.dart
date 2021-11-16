import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  final product = snapshot.data;
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 400,
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                            ),
                            items: product!['image'].map<Widget>((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      imageUrl: i,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['productName'],
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // price
                                Text(
                                  'Rs. ${product['price']}',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Product details",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("COPY"),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  product["productDescription"],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.favorite_border_sharp),
                    Text("Wishlist"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO:
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.share_outlined),
                    Text("Share"),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 10),
                ),
                onPressed: () {
                  // TODO:
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text("Add to cart"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
