import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselSliderMain extends StatelessWidget {
  const CarouselSliderMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        autoPlay: true,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
      ),
      items: [1, 2, 3].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xff264653),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Text $i',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
