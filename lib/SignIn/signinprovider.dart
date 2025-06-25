

import 'package:flutter/cupertino.dart';

class signinprovider with ChangeNotifier {

  TextEditingController empIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  String? validateempIDTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Employee ID";
    }
    return null;
  }

  String? validatepasswordTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Employee ID";
    }
    return null;
  }
}