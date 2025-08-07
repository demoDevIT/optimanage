import 'package:flutter/material.dart';
import 'package:optimanage/SignIn/SignInScreen.dart';
import 'package:optimanage/Home/home_provider.dart';
import 'package:optimanage/Home/home_screen.dart';
import 'package:optimanage/utils/PrefUtil.dart';
import 'package:provider/provider.dart';

class OnboardingScreenPage extends StatefulWidget {
  const OnboardingScreenPage({Key? key}) : super(key: key);

  @override
  State<OnboardingScreenPage> createState() => _OnboardingScreenPageState();
}

class _OnboardingScreenPageState extends State<OnboardingScreenPage> {
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final String? isLoggedIn = await PrefUtil.getUserLoggedWay();

    if (!mounted) return;

    if (isLoggedIn == "true") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => HomeProvider(),
            child: const HomeScreen(),
          ),
        ),
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isChecking = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F8FC),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show onboarding only if not already logged in
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Image.asset(
                    'assets/logos/onboarding.png',
                    width: double.infinity,
                    height: 533,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Manage Your Daily Tasks',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'This productive tool is designed to help you better '
                          'manage your task project-wise conveniently!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 40.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF25507C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Let’s Start",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
