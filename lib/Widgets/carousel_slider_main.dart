import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderMain extends StatelessWidget {
  CarouselSliderMain({Key? key}) : super(key: key);

  final List<String> banners = [
    "assets/images/slider_1.png",
    "assets/images/slider_2.png",
    "assets/images/slider_3.png",
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        // disableCenter: true,
        autoPlay: true,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
      ),
      items: banners.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff264653),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(i),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Center(
              //   child: Text(
              //     'Text $i',
              //     style: const TextStyle(fontSize: 16.0),
              //   ),
              // ),
            );
          },
        );
      }).toList(),
    );
  }
}
