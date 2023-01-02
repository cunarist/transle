import 'package:flutter/material.dart';

class MyAppState with ChangeNotifier {
  var tester = TestStateCategory();
  var someHelper = SomeHelperStateCategory();

  void setState(Function job) async {
    await job(this);
    notifyListeners();
  }
}

class TestStateCategory {
  int counterValue = 0;
}

class SomeHelperStateCategory {
  int someValue = 0;
  String anotherValue = "";
}
