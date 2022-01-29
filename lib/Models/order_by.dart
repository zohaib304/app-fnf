import 'dart:developer';

import 'package:flutter/cupertino.dart';

class OrderBy with ChangeNotifier {
  late int selectedTile = 0;

  void setSelectedTile(int? index) {
    selectedTile = index!;
    log(selectedTile.toString());
    notifyListeners();
  }
}
