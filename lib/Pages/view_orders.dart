import 'package:android_app_fnf/Widgets/complete_orders.dart';
import 'package:android_app_fnf/Widgets/pending_orders.dart';
import 'package:flutter/material.dart';

class ViewOrders extends StatelessWidget {
  const ViewOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          title: const Text('My Orders'),
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Colors.black87,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              color: Colors.black38,
            ),
            tabs: const [
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Completed',
              ),
              Tab(
                text: 'Cancelled',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingOrders(),
            CompleteOrders(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
