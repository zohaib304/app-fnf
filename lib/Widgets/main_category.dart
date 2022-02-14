import 'package:flutter/material.dart';

class MainCategory extends StatelessWidget {
  const MainCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/bracelet.png'),
                  const SizedBox(height: 5),
                  const Text('Bracelet'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/flipflop.png'),
                  const SizedBox(height: 5),
                  const Text('Flip Flop'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/scarf.png'),
                  const SizedBox(height: 5),
                  const Text('Scarf'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/swimming.png'),
                  const SizedBox(height: 5),
                  const Text('Swimming'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/tie.png'),
                  const SizedBox(height: 5),
                  const Text('Tie'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/bag.png'),
                  const SizedBox(height: 5),
                  const Text('Bags'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/earring.png'),
                  const SizedBox(height: 5),
                  const Text('Earrings'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/jeans.png'),
                  const SizedBox(height: 5),
                  const Text('Jeans'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/shirt.png'),
                  const SizedBox(height: 5),
                  const Text('Shirts'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('assets/icons/wedding.png'),
                  const SizedBox(height: 5),
                  const Text('Wedding'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
