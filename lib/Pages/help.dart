import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({ Key? key }) : super(key: key);

  static const String routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: const Center(
        child: Text('Help'),
      ),
    );
  }
}