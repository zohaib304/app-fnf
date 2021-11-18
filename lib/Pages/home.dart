import 'package:android_app_fnf/Models/product.dart';
import 'package:android_app_fnf/Models/product_argumets.dart';
import 'package:android_app_fnf/Services/products.dart';
import 'package:android_app_fnf/Widgets/carousel_slider_main.dart';
import 'package:android_app_fnf/Widgets/sign_in_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final firebaseUser = context.watch<User?>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
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
              Navigator.pushNamed(context, '/profile');
            }
          },
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe9ecef),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                child: const TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Search',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.grey[600],
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const CarouselSliderMain(),
            const SizedBox(height: 10),
            const Divider(),
            // filter icon and dropdown
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
              color: Colors.black12,
              child: const Text("Filter be add here."), // TODO:
            ),

            const SizedBox(height: 10),
            StreamBuilder<List<Product>>(
              stream: products.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4 / 6.2,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/product-detail',
                              arguments: ProductArguments(
                                snapshot.data![index].id,
                                snapshot.data![index].name,
                                snapshot.data![index].price,
                                snapshot.data![index].supplierId,
                              ));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black12,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 180,
                                  enableInfiniteScroll: false,
                                  viewportFraction: 1,
                                ),
                                items: snapshot.data![index].images.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(5),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: i,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].name,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    // price
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs. ${snapshot.data![index].price.toInt()}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Share.share(
                                              snapshot.data![index].name,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.share_outlined,
                                            size: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Text(
                                            "4.8",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        const Text("Ratings"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text("Loading...");
              },
            ),
          ],
        ),
      ),
    );
  }
}
