import 'package:flutter/material.dart';

class ViewOrders extends StatelessWidget {
  const ViewOrders({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Orders'),
      ),
      body: const Center(
        child: Text('View Orders'),
      ),
    );
  }
}