// home_provider.dart
import 'package:flutter/material.dart';
import 'package:optimanage/SignIn/SignInScreen.dart';
import 'package:optimanage/utils/PrefUtil.dart';

class HomeProvider with ChangeNotifier {
  Future<void> logoutUser(BuildContext context) async {
    // Clear saved user data
    await PrefUtil.clearAll(); // You should already have this or similar method

    // Navigate to SignInScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SignInScreen()),
          (Route<dynamic> route) => false,
    );
  }
}
