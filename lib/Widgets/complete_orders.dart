import 'dart:developer';

import 'package:android_app_fnf/Services/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class CompleteOrders extends StatefulWidget {
  const CompleteOrders({Key? key}) : super(key: key);

  @override
  _CompleteOrdersState createState() => _CompleteOrdersState();
}

class _CompleteOrdersState extends State<CompleteOrders>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    final getOrders = Provider.of<Order>(context);
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        getOrders.getOrders(firebaseUser!.uid);
        log("refress");
      },
      child: PaginateFirestore(
        //item builder type is compulsory.
        itemBuilder: (context, documentSnapshots, index) {
          final data = documentSnapshots[index].data() as Map?;
          return Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        data!['image'],
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    // color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['productName'],
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rs ' + data['productPrice'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Quantity: ' + data['quantity'].toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        // orderBy is compulsory to enable pagination
        query: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: firebaseUser!.uid)
            .where('status', isEqualTo: 'completed'),

        //Change types accordingly
        itemBuilderType: PaginateBuilderType.listView,
        // to fetch real-time data
        isLive: true,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
