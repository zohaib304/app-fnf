import 'package:flutter/material.dart';

class OrderConfirmed extends StatelessWidget {
  const OrderConfirmed({Key? key}) : super(key: key);

  static const String routeName = '/order-confirmed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Order Confirmed',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Text(
              'Your order has been placed successfully',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
