// home_provider.dart
import 'package:flutter/material.dart';
import 'package:optimanage/SignIn/SignInScreen.dart';
import 'package:provider/provider.dart';
import '../../utils/PrefUtil.dart';
import '../SignIn/signinprovider.dart';
import '../main.dart';
import '../utils/RightToLeftRoute.dart';

class HomeProvider with ChangeNotifier {


// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (_) => ChangeNotifierProvider(
// create: (_) => signinprovider(),
// child: const SignInScreen(),
// ),
// ),
// (route) => false,
// );
}
