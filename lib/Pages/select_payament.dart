import 'dart:developer';

import 'package:android_app_fnf/Services/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum paymentType { cashonDelivery, card }

class SelectPayment extends StatefulWidget {
  const SelectPayment({Key? key}) : super(key: key);

  static const String routeName = '/select-payment';

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  paymentType? _paymentType = paymentType.cashonDelivery;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final firebaseUser = context.watch<User?>();
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Select Payment',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sub Total:',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder(
                    stream: cart.getTotalPrice(firebaseUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RadioListTile<paymentType>(
              value: paymentType.cashonDelivery,
              groupValue: _paymentType,
              selected: _paymentType == paymentType.cashonDelivery,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (paymentType? value) {
                setState(() {
                  _paymentType = value;
                  log(_paymentType.toString());
                });
              },
              title: const Text('Cash on Delivery'),
              subtitle: const Text('Pay with cash on delivery'),
            ),
            RadioListTile<paymentType>(
              value: paymentType.card,
              groupValue: _paymentType,
              selected: _paymentType == paymentType.card,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (paymentType? value) {
                setState(() {
                  _paymentType = value;
                  log(_paymentType.toString());
                });
              },
              title: const Text('Pay with Cart'),
              // pay with your credit card or debit card
              subtitle: const Text('Pay with your credit card or debit card'),
              // isThreeLine: true,
              toggleable: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            onPressed: () {
              // TODO: implement
            },
            child: const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
