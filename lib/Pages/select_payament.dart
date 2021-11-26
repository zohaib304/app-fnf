import 'dart:developer';

import 'package:flutter/material.dart';

enum PaymentMethod { cashOnDelivery, card }

class SelectPayment extends StatefulWidget {
  const SelectPayment({Key? key}) : super(key: key);

  static const String routeName = '/select-payment';

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  int _index = 0;
  PaymentMethod? _paymentMethod = PaymentMethod.cashOnDelivery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        foregroundColor: Colors.black87,
        title: const Text('Order Process'),
      ),
      body: Stepper(
        currentStep: _index,
        type: StepperType.horizontal,
        onStepCancel: _index == 0
            ? null
            : () {
                setState(() {
                  _index -= 1;
                });
              },
        onStepContinue: () {
          final isLastStep = _index == 2;
          if (isLastStep) {
            log("Completed");
          } else {
            setState(() {
              _index += 1;
            });
          }
        },
        onStepTapped: (int index) {
          setState(() {
            _index = index;
          });
        },
        steps: [
          Step(
            state: _index == 0 ? StepState.indexed : StepState.complete,
            title: const Text("Payment"),
            content: Column(
              children: [
                RadioListTile<PaymentMethod>(
                  title: const Text('Cash on Delivery'),
                  subtitle: const Text('Pay with cash on delivery'),
                  value: PaymentMethod.cashOnDelivery,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
                RadioListTile<PaymentMethod>(
                  title: const Text('Card'),
                  subtitle: const Text('Pay with credit card'),
                  value: PaymentMethod.card,
                  groupValue: _paymentMethod,
                  onChanged: (PaymentMethod? value) {
                    setState(() {
                      _paymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            isActive: _index >= 0,
          ),
          Step(
            state: _index == 1 ? StepState.indexed : StepState.complete,
            title: const Text("Address"),
            content: const Text("Add Address"),
            isActive: _index >= 1,
          ),
          Step(
            state: _index == 2 ? StepState.indexed : StepState.complete,
            title: const Text("Place Order"),
            content: const Text("Place an Order"),
            isActive: _index >= 2,
          ),
        ],
      ),
    );
  }
}
