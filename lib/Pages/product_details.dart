import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late String shopName = '';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      log("hello");
    } else {
      log("nah");
    }
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
                  // FirebaseFirestore.instance
                  //     .collection("suppliers")
                  //     .doc(product!['supplier_id'])
                  //     .get()
                  //     .then((value) {
                  //   if (mounted) {
                  //     setState(() {
                  //       shopName = value.data()!['shopName'];
                  //     });
                  //   }
                  // });
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
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sold By",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "shopName",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    // TODO: Navigate to shop page
                                  },
                                  child: const Text("Go to Store"),
                                ),
                              ],
                            ),
                          )
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
                  // signIn.signOut().then((value) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //       behavior: SnackBarBehavior.floating,
                  //       content: Text("You're now logged out"),
                  //     ),
                  //   );
                  // });
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
                  if (firebaseUser == null) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Please login first to add to cart",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                child: const Text("Sign in with Google"),
                                onPressed: () async {
                                  // TODO:
                                  try {
                                    // Trigger the authentication flow
                                    final GoogleSignInAccount? googleUser =
                                        await GoogleSignIn().signIn();

                                    // Obtain the auth details from the request
                                    final GoogleSignInAuthentication?
                                        googleAuth =
                                        await googleUser?.authentication;

                                    // Create a new credential
                                    final credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: googleAuth?.accessToken,
                                      idToken: googleAuth?.idToken,
                                    );

                                    // Once signed in, return the UserCredential
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);

                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content:
                                            Text("Successfully logged In."),
                                      ),
                                    );
                                  } catch (e) {
                                    log(e.toString());
                                    log(e.toString());
                                  }
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  // pop if cancel
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("You're good to go"),
                      ),
                    );
                  }
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
