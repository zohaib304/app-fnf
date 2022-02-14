import 'package:android_app_fnf/Models/order_by.dart';
import 'package:android_app_fnf/Models/product_argumets.dart';
import 'package:android_app_fnf/Widgets/carousel_slider_main.dart';
import 'package:android_app_fnf/Widgets/help_widget.dart';
import 'package:android_app_fnf/Widgets/main_category.dart';
import 'package:android_app_fnf/Widgets/sign_in_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final orderBy = Provider.of<OrderBy>(context);
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
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(
            child: CarouselSliderMain(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          const SliverToBoxAdapter(
            child: HelpWidget(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          const SliverToBoxAdapter(
            child: MainCategory(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            backgroundColor: const Color(0xffFCFAFA),
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              title: ButtonBar(
                alignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    child: const Text(
                      'Order By',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: 200,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 2,
                                itemBuilder: (context, index) {
                                  return RadioListTile<int>(
                                    value: index,
                                    groupValue: orderBy.selectedTile,
                                    onChanged: orderBy.setSelectedTile,
                                    title: Text("Text format ${index + 1}"),
                                  );
                                },
                              ),
                            );
                          });
                    },
                  ),
                  const VerticalDivider(
                    color: Colors.black26,
                  ),
                  TextButton(
                    child: const Text(
                      'Categories',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                  const VerticalDivider(
                    color: Colors.black26,
                  ),
                  TextButton(
                    child: const Text(
                      'Button',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: PaginateFirestore(
              onEmpty: const Text("Something went wrong."),
              initialLoader: SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              itemBuilderType:
                  PaginateBuilderType.gridView, //Change types accordingly
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4 / 5.5,
              ),
              itemBuilder: (context, documentSnapshots, index) {
                final data = documentSnapshots[index].data() as Map?;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product-detail',
                      arguments: ProductArguments(
                        documentSnapshots[index].id,
                        data!["productName"],
                        double.parse(data["price"]),
                        data["supplier_id"],
                        data['image'][0],
                        data['shopName'],
                      ),
                    );
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
                          items: data!['image'].map<Widget>((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
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
                                data['productName'],
                                overflow: TextOverflow.fade,
                                maxLines: 1,
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
                                    'Rs. ${data['price']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Share.share(
                                        data['productName'],
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      size: 22,
                                    ),
                                  ),
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
              // orderBy is compulsory to enable pagination
              query: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('timestamp', descending: true),
              // to fetch real-time data
              isLive: true,
            ),
          ),
        ],
      ),
    );
  }
}
