import 'package:android_app_fnf/Models/order_details_arguments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key}) : super(key: key);

  static const String routeName = '/order-details';

  @override
  Widget build(BuildContext context) {
    final orderdetails =
        ModalRoute.of(context)?.settings.arguments as OrderDetailsArguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        orderdetails.imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(2),
                    // color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderdetails.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Quantity: " + orderdetails.quantity.toString()),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Shipping Address",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              orderdetails.address,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              orderdetails.city + ", " + orderdetails.state,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              orderdetails.phone,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // tracking steps
            const Text(
              "Tracking",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              steps: const [
                Step(
                  title: Text("Order Placed"),
                  content: Text("Your order has been placed."),
                  isActive: true,
                  state: StepState.complete,
                ),
                Step(
                  title: Text("Order Confirmed"),
                  content: Text("Order Confirmed"),
                  isActive: false,
                  state: StepState.complete,
                ),
                Step(
                  title: Text("Order Shipped"),
                  content: Text("Order Shipped"),
                  isActive: false,
                  state: StepState.complete,
                ),
                Step(
                  title: Text("Order Delivered"),
                  content: Text("Order Delivered"),
                  isActive: false,
                  state: StepState.complete,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              orderdetails.paymentMethod,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Questions?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "If you have any questions about your order, please contact us.",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {},
                  child: Text("Visit Help Center"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
