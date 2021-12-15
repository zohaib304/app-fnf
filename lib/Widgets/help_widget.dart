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
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Learn How To Earn Money?",
              style: TextStyle(
                // fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Chip(
              label: const Text("Learn More"),
              labelStyle: const TextStyle(
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
