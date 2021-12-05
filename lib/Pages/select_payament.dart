import 'dart:developer';
import 'package:android_app_fnf/Models/address.dart';
import 'package:android_app_fnf/Models/cart_items.dart';
import 'package:android_app_fnf/Services/add_new_address.dart';
import 'package:android_app_fnf/Services/cart.dart';
import 'package:android_app_fnf/Services/order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO The stepper need to be in different file and improve the state throughout the app

enum PaymentMethod { cashOnDelivery, card }

class SelectPayment extends StatefulWidget {
  const SelectPayment({Key? key}) : super(key: key);

  static const String routeName = '/select-payment';

  @override
  State<SelectPayment> createState() => _SelectPaymentState();
}

class _SelectPaymentState extends State<SelectPayment> {
  int _index = 0;
  int radioValue = -1;
  double _margin = 0.0;
  String _selectedAddress = '';
  bool _placeOrder = false;
  bool isLoading = false;
  PaymentMethod? _paymentMethod = PaymentMethod.cashOnDelivery;
  @override
  Widget build(BuildContext context) {
    final addressList = Provider.of<AddNewAddress>(context);
    final firebaseUser = context.watch<User?>();
    final cart = Provider.of<Cart>(context);
    final placeOrder = Provider.of<Order>(context);
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
        controlsBuilder: (BuildContext context,
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_index > 0)
                TextButton(
                  onPressed: onStepCancel,
                  child: const Text('Back'),
                ),
              if (_index < 2)
                ElevatedButton(
                  onPressed: onStepContinue,
                  child: const Text('Next'),
                ),
              if (_index == 2)
                ElevatedButton(
                  onPressed: () {
                    try {
                      setState(() {
                        _placeOrder = true;
                      });
                      cart.getDocIds(firebaseUser!.uid).then((_) {
                        placeOrder.addOrder(firebaseUser.uid, 'cartId');
                      }).then((value) {
                        cart.clearCart(firebaseUser.uid);
                        Navigator.pushNamed(context, '/order-confirmed');
                      });
                    } catch (e) {
                      setState(() {
                        _placeOrder = false;
                      });
                      log(e.toString());
                    }
                  },
                  child: _placeOrder
                      ? const Text("Loading")
                      : const Text('Place Order'),
                ),
            ],
          );
        },
        steps: [
          Step(
            state: _index == 0 ? StepState.indexed : StepState.complete,
            title: const Text("Payment"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<PaymentMethod>(
                  tileColor: Colors.white,
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
                const SizedBox(
                  height: 5.0,
                ),
                RadioListTile<PaymentMethod>(
                  tileColor: Colors.white,
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
                const SizedBox(height: 20),
                const Text(
                  "Your Product",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  child: StreamBuilder<List<CartItem>>(
                    stream: cart.getCartItems(firebaseUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final cartItems = snapshot.data;
                        if (cartItems!.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: const Center(
                              child: Text(
                                'No Product in Cart',
                                // style: TextStyle(
                                //   fontSize: 20,
                                // ),
                              ),
                            ),
                          );
                        }
                        return Scrollbar(
                          interactive: true,
                          child: ListView.builder(
                            // controller: ScrollController(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = cartItems[index];
                              return Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 10, right: 5, left: 5),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 4,
                                          offset: const Offset(1,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                cartItem.image,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            // color: Colors.amber,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartItem.name,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Rs ${cartItem.price.round()}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: cartItem
                                                                    .quantity >
                                                                1
                                                            ? () {
                                                                try {
                                                                  // set state to show loading
                                                                  setState(() {
                                                                    isLoading =
                                                                        true;
                                                                  });
                                                                  cart
                                                                      .removeFromCart(
                                                                          cartItem
                                                                              .productId)
                                                                      .then(
                                                                          (value) {
                                                                    // set state to hide loading
                                                                    setState(
                                                                        () {
                                                                      isLoading =
                                                                          false;
                                                                    });
                                                                  });
                                                                } catch (e) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;
                                                                  });
                                                                }
                                                              }
                                                            : null,
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                              color: cartItem
                                                                          .quantity >
                                                                      1
                                                                  ? Colors.black
                                                                  : Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        '${cartItem.quantity}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      InkWell(
                                                        onTap: () {
                                                          try {
                                                            // set state to show loading
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            cart
                                                                .increaseQuantity(
                                                                    cartItem
                                                                        .productId)
                                                                .then((value) {
                                                              // set state to hide loading
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            });
                                                          } catch (e) {
                                                            setState(() {
                                                              isLoading = false;
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              size: 20,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        cart.deleteFromCart(cartItem.productId);
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Theme.of(context).primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
            isActive: _index >= 0,
          ),
          Step(
            state: _index == 1 ? StepState.indexed : StepState.complete,
            title: const Text("Address"),
            content: StreamBuilder<List<ShippingAddress>>(
              stream: addressList.getAddress(firebaseUser.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final address = snapshot.data;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: address!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 5.0,
                    ),
                    itemBuilder: (context, index) {
                      return RadioListTile<int>(
                        tileColor: Colors.white,
                        // selected: _selectedAddress == address[index].id,
                        value: index,
                        groupValue: radioValue,
                        onChanged: (ind) {
                          setState(() {
                            radioValue = ind!;
                            _selectedAddress = address[index].id;
                          });
                          log(_selectedAddress);
                        },
                        title: Text(address[index].customerName),
                        subtitle: Text(
                          address[index].address,
                          maxLines: 3,
                        ),
                        // isThreeLine: true,
                        secondary: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            // TODO: CHANGE TO EDIT ADDRESS
                            addressList.deleteAddress(address[index].id);
                          },
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
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '${_paymentMethod?.toString()}', // TODO payment method
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                // INFO TEXT: Go back and change address
                const Text(
                  'NOTE: Go back if you want to change the address.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                FutureBuilder<ShippingAddress>(
                  future: addressList.getAddressById(_selectedAddress),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final address = snapshot.data;
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address!.customerName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              address.address,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              '${address.city}, ${address.state} ${address.zipCode}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                            // PHONE
                            const SizedBox(height: 10),
                            Text(
                              'Phone: ${address.phone}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                const SizedBox(height: 20),
                // add margin price and total
                const Text(
                  "Add your margin",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add your margin"),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _margin = 0;
                              });
                            } else {
                              setState(() {
                                _margin = double.parse(value);
                              });
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _margin = 0;
                              });
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            prefix: Text("Rs "),
                            hintText: "0",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // info container with light blue background
                Container(
                  width: double.infinity,
                  color: Colors.lightGreen[100],
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("You will earn amount of "),
                      Text(
                        "Rs " + _margin.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This is the total amount will be collected from the customer. Make sure you have already contacted the customer and confirmed the order.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<double>(
                  stream: cart.getTotalPrice(firebaseUser.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        "Rs " + (snapshot.data! + _margin).toString(),
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
