import 'dart:developer';
import 'package:android_app_fnf/Models/address.dart';
import 'package:android_app_fnf/Services/add_new_address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PaymentMethod { cashOnDelivery, card }

class SelectPayment extends StatefulWidget {
  const SelectPayment({Key? key}) : super(key: key);

  static const String routeName = '/select-payment';

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  int _index = 0;
  int radioValue = 0;
  PaymentMethod? _paymentMethod = PaymentMethod.cashOnDelivery;
  @override
  Widget build(BuildContext context) {
    final addressList = Provider.of<AddNewAddress>(context);
    final firebaseUser = context.watch<User?>();
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
          log(_index.toString());
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
                const Divider(
                  height: 1.0,
                  color: Colors.black,
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
            content: StreamBuilder<List<ShippingAddress>>(
              stream: addressList.getAddress(firebaseUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final address = snapshot.data;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: address!.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1.0,
                      color: Colors.black,
                    ),
                    itemBuilder: (context, index) {
                      return RadioListTile<int>(
                        value: index,
                        groupValue: radioValue,
                        onChanged: (ind) {
                          setState(() => radioValue = ind!);
                        },
                        title: Text(address[index].customerName),
                        subtitle: Text(
                          address[index].address,
                          maxLines: 3,
                        ),
                        isThreeLine: true,
                        secondary: SizedBox(
                          width: 96,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  //TODO: edit address
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  addressList.deleteAddress(address[index].id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
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
      floatingActionButton: _index == 1
          ? FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                Navigator.pushNamed(context, '/new-address');
              },
              tooltip: 'New Address',
              icon: const Icon(Icons.add),
              // shape: const RoundedRectangleBorder(
              //   borderRadius: BorderRadius.all(
              //     Radius.circular(15.0),
              //   ),
              // ),
              label: const Text(
                'New Address',
              ),
            )
          : null,
    );
  }
}
