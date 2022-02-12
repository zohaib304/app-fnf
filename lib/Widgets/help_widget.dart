import 'package:flutter/material.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/help');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xffDFF0FE),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Learn How To Earn Money?",
              style: TextStyle(
                // fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Chip(
              label: Text("Learn More"),
              labelStyle: TextStyle(
                color: Colors.white,
              ),
              backgroundColor: Color(0xff00A6B9),
            )
          ],
        ),
      ),
    );
  }
}
