import 'dart:developer';

import 'package:android_app_fnf/Models/product_argumets.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:android_app_fnf/Widgets/sign_in_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            onPressed: () {},
          ),
          Stack(
            children: [
              Positioned(
                child: IconButton(
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
                      Navigator.pushNamed(context, '/select-payment');
                    }
                  },
                ),
              ),
              // Positioned(
              //   top: 10,
              //   right: 10,
              //   child: Container(
              //     width: 15,
              //     height: 15,
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Center(
              //       child: StreamBuilder(
              //         stream: addToCart.getTotalQuantity(firebaseUser!.uid),
              //         builder: (context, snapshot) {
              //           if (snapshot.hasData) {
              //             return Text(
              //               snapshot.data.toString(),
              //               style: const TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 10,
              //               ),
              //             );
              //           }
              //           return Container();
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
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
                                  style: OutlinedButton.styleFrom(
                                    primary: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    // TODO:
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
        child: StreamBuilder<bool>(
          //TODO CHECK OF USER IS LOGGED IN OR NOT
          stream: addToCart.checkIfProductExists(
              product.productId, firebaseUser!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // log(product.productId);
              final isExist = snapshot.data;
              return isExist!
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    30, 10, 30, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                // TODO:
                                Share.share("Product Name");
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
                          Directionality(
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
                                label: const Text(
                                  "CHEKOUT",
                                  // style: TextStyle(
                                  //   color: Colors.black54,
                                  // ),
                                ),
                                onPressed: () {
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
                                    Navigator.pushNamed(
                                        context, '/select-payment');
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    30, 10, 30, 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () {
                                // TODO:
                                Share.share("Product Name");
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
                          Directionality(
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
                              label: !_loading
                                  ? const Text("ADD TO CART")
                                  : const Text(
                                      "...ADDING",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                              onPressed: !_loading
                                  ? () {
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
                                        log(isExist.toString());
                                        if (!isExist) {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text("Attention"),
                                                content: const Text(
                                                    "You have 1 Product in your cart already. To make delivery faster for your customer, only 1 order is allow at a time.\n\nDo you want to continue?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("Yes"),
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
                                                                firebaseUser
                                                                    .uid)!
                                                            .then((value) {
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
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              const SnackBar(
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                content: Text(
                                                                    "Product added to cart"),
                                                              ),
                                                            );
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
                                                  ),
                                                  TextButton(
                                                    child: const Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
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
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  content: Text(
                                                      "Product added to cart"),
                                                ),
                                              );
                                            });
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: Text(
                                                    "Something went wrong please try later."),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return const Text("Add to cart");
          },
        ),
        // child: Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        //   decoration: BoxDecoration(
        //     border: Border(
        //       top: BorderSide(
        //         color: (Colors.grey[300])!,
        //         width: 1,
        //       ),
        //     ),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Directionality(
        //         textDirection: TextDirection.rtl,
        //         child: ElevatedButton.icon(
        //           style: ElevatedButton.styleFrom(
        //             primary: Colors.white,
        //             elevation: 0,
        //             padding:
        //                 const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(50),
        //             ),
        //           ),
        //           onPressed: () {
        //             // TODO:
        //             Share.share("Product Name");
        //           },
        //           icon: Container(
        //             padding: const EdgeInsets.all(3),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(50),
        //               color: Colors.grey[400],
        //             ),
        //             child: const Icon(
        //               Icons.arrow_upward,
        //               color: Colors.white,
        //             ),
        //           ),
        //           label: const Text(
        //             "SHARE THIS",
        //             style: TextStyle(
        //               color: Colors.black54,
        //             ),
        //           ),
        //         ),
        //       ),
        //       Directionality(
        //         textDirection: TextDirection.rtl,
        //         child: ElevatedButton.icon(
        //           style: ElevatedButton.styleFrom(
        //             primary: Theme.of(context).primaryColor,
        //             elevation: 0,
        //             padding:
        //                 const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(50),
        //             ),
        //           ),
        //           icon: Container(
        //             padding: const EdgeInsets.all(3),
        //             decoration: BoxDecoration(
        //               borderRadius: BorderRadius.circular(50),
        //               color: Colors.white,
        //             ),
        //             child: Icon(
        //               Icons.chevron_left,
        //               color: Theme.of(context).primaryColor,
        //             ),
        //           ),
        //           label: !_loading
        //               ? const Text("ADD TO CART")
        //               : const Text(
        //                   "...ADDING",
        //                   style: TextStyle(
        //                     color: Colors.black54,
        //                   ),
        //                 ),
        //           onPressed: !_loading
        //               ? () {
        //                   // ignore: unnecessary_null_comparison
        //                   if (firebaseUser == null) {
        //                     showModalBottomSheet(
        //                       shape: const RoundedRectangleBorder(
        //                         //the rounded corner is created here
        //                         borderRadius: BorderRadius.only(
        //                           topLeft: Radius.circular(20),
        //                           topRight: Radius.circular(20),
        //                         ),
        //                       ),
        //                       context: context,
        //                       builder: (context) {
        //                         return const SignInSheet();
        //                       },
        //                     );
        //                   } else {
        //                     try {
        //                       // set _loading to true
        //                       setState(() {
        //                         _loading = true;
        //                       });
        //                       addToCart
        //                           .addToCart(
        //                         product.productId,
        //                         product.name,
        //                         product.price,
        //                         product.supplierId,
        //                         firebaseUser.uid,
        //                         product.imageUrl,
        //                       )
        //                           .then((value) {
        //                         // set _loading to false
        //                         setState(() {
        //                           _loading = false;
        //                         });
        //                         ScaffoldMessenger.of(context).showSnackBar(
        //                           const SnackBar(
        //                             behavior: SnackBarBehavior.floating,
        //                             content: Text("Product added to cart"),
        //                           ),
        //                         );
        //                       });
        //                     } catch (e) {
        //                       ScaffoldMessenger.of(context).showSnackBar(
        //                         const SnackBar(
        //                           behavior: SnackBarBehavior.floating,
        //                           content: Text(
        //                               "Something went wrong please try later."),
        //                         ),
        //                       );
        //                     }
        //                   }
        //                 }
        //               : null,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
