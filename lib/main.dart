import 'package:flutter/material.dart';
import 'package:optimanage/Home/home_provider.dart';
import 'package:optimanage/assignedtask/assignedtask_provider.dart';
import 'package:optimanage/forget/forget_provider.dart';
import 'package:optimanage/notaskassign/notaskassign_provider.dart';
import 'package:optimanage/selftask/selftask_provider.dart';
import 'package:optimanage/tasksummary/tasksummary_provider.dart';
import 'package:optimanage/timesheet/timesheet_provider.dart';
import 'package:provider/provider.dart';
import 'package:optimanage/RD/rd_provider.dart';
import 'package:optimanage/profile/profile_provider.dart';
// // import 'package:optimanage/forget/forget_provider.dart';
// import 'package:optimanage/assignedtask/assignedtask_provider.dart';
import 'SignIn/signinprovider.dart';
import 'onboarding/onboarding_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => timesheet_provider(_)),
          ChangeNotifierProvider(create: (_) => signinprovider()),
          ChangeNotifierProvider(create: (_) => TaskSummaryProvider()),
          ChangeNotifierProvider(create: (_) => NoTaskAssignProvider()),
          ChangeNotifierProvider(create: (_) => RdProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => AssignedTaskProvider()),
          ChangeNotifierProvider(create: (_) => ForgetProvider()),
          ChangeNotifierProvider(create: (_) => SelfTaskProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider())
        ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimanage',navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnboardingScreenPage(),
    );
  }
}

