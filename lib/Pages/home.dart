import 'package:android_app_fnf/Widgets/carousel_slider_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffe9ecef),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.75,
                child: const TextField(
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.transparent,
                    hintText: 'Search',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [SizedBox(height: 10), CarouselSliderMain()],
        ),
      ),
    );
  }
}
