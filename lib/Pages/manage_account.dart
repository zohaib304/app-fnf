import 'package:flutter/material.dart';

class ManageAccount extends StatelessWidget {
  const ManageAccount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Account'),
      ),
      body: const Center(
        child: Text('Manage Account'),
      ),
    );
  }
}