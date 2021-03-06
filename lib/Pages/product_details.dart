import 'package:android_app_fnf/Models/product_argumets.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:android_app_fnf/Widgets/sign_in_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  static const routeName = '/product-detail';

  // set loading to show loading indicator

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late String shopName = '';
  bool _loading = false;

  @override
  void initState() {
    FirebaseAnalytics.instance.logEvent(name: 'product_detail_view');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as ProductArguments;
    final firebaseUser = context.watch<User?>();
    final addToCart = Provider.of<Cart>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.grey[600]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await FirebaseAnalytics.instance.logEvent(
                name: 'product_detail_search',
                parameters: {'product_id': product.productId},
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {
              if (firebaseUser == null) {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    //the rounded corner is created here
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return const SignInSheet();
                  },
                );
              } else {
                Navigator.pushNamed(
                  context,
                  '/select-payment',
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .doc(product.productId)
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rs. ${product['price']}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.share,
                                              color: Colors.black54,
                                            ),
                                            onPressed: () {
                                              Share.share(
                                                  'Check out this product: ${product['productName']}');
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: product['productDescription'],
                                          ),
                                        ).then((value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text("Copied."),
                                            ),
                                          );
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                      ),
                                      child: const Text(
                                        "COPY",
                                      ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                    Text(
                                      product['shopName'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          product['supplier_id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "GO TO STORE",
                                  ),
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
        color: const Color(0xffF5F6F8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: (Colors.grey[300])!,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    elevation: 0,
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Share.share(product.name);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[400],
                    ),
                    child: const Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  label: const Text(
                    "SHARE THIS",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              StreamBuilder<bool>(
                initialData: false,
                stream: addToCart.checkIfProductExists(
                    product.productId, firebaseUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    bool? isExist = snapshot.data;
                    return StreamBuilder<bool>(
                      initialData: true,
                      stream: addToCart.isCartEmpty(firebaseUser.uid),
                      builder: (context, snapshot) {
                        bool? isEmpty = snapshot.data;
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  30, 10, 30, 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            icon: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            label: (_loading)
                                ? const Text(
                                    "...ADDING",
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  )
                                : Text(isExist! ? "CHECKOUT" : "ADD TO CART"),
                            onPressed: (isExist!)
                                ? () {
                                    Navigator.pushNamed(
                                      context,
                                      '/select-payment',
                                    );
                                  }
                                : () {
                                    // ignore: unnecessary_null_comparison
                                    if (firebaseUser == null) {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          //the rounded corner is created here
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return const SignInSheet();
                                        },
                                      );
                                    } else {
                                      // if the current product is not in cart
                                      // or the cart is not empty
                                      if (!isEmpty!) {
                                        // if the cart is not empty and the product is not in cart
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: const Text(
                                                "Your cart already contains products. \n\nDo you want to discard them and add this to cart?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "CANCEL",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    try {
                                                      // set _loading to true
                                                      setState(() {
                                                        _loading = true;
                                                      });
                                                      // add to cart
                                                      addToCart
                                                          .clearCart(
                                                              firebaseUser.uid)
                                                          ?.then((value) {
                                                        addToCart
                                                            .addToCart(
                                                          product.productId,
                                                          product.name,
                                                          product.price,
                                                          product.supplierId,
                                                          firebaseUser.uid,
                                                          product.imageUrl,
                                                        )
                                                            .then((value) {
                                                          // set _loading to false
                                                          setState(() {
                                                            _loading = false;
                                                          });
                                                        });
                                                      });
                                                    } catch (e) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          content: Text(
                                                              "Something went wrong please try later."),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Text(
                                                    "YES",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      } else {
                                        try {
                                          // set _loading to true
                                          setState(() {
                                            _loading = true;
                                          });
                                          // add to cart
                                          addToCart
                                              .clearCart(firebaseUser.uid)
                                              ?.then((value) {
                                            addToCart
                                                .addToCart(
                                              product.productId,
                                              product.name,
                                              product.price,
                                              product.supplierId,
                                              firebaseUser.uid,
                                              product.imageUrl,
                                            )
                                                .then((value) {
                                              // set _loading to false
                                              setState(() {
                                                _loading = false;
                                              });
                                            });
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            content: Text(
                                                "Something went wrong please try later."),
                                          ));
                                        }
                                      }
                                    }
                                  },
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
