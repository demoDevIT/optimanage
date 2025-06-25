import 'package:flutter/material.dart';
import 'package:optimanage/SignIn/signinprovider.dart';
import 'package:provider/provider.dart';
import '../Home/home_screen.dart';
import '../forget/forget_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // Hide keyboard on outside tap
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Consumer<signinprovider>(
              builder: (context, provider, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      // 👈 Top and Left margin
                      child: Image.asset(
                        'assets/logos/logo.png',
                        width: 105,
                        height: 110,
                      ),
                    ),

                    // Logo Image
                    // Image.asset(
                    //   'assets/logos/logo.png', // Your logo
                    //   width: 105,
                    //   height: 110,
                    //
                    // ),

                    const SizedBox(height: 24),

                    // Sign In Heading Image
                    Image.asset(
                      'assets/logos/SignIn.png', // Your heading image
                      width: 345,
                      height: 99,
                    ),

                    const SizedBox(height: 16),

                    // Description Text (if you want to replace the heading image with text)
                    // const Text(
                    //   'It was popularised in the 1960s with the release of Letraset sheets...',
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(fontSize: 14, color: Colors.grey),
                    // ),

                    const SizedBox(height: 32),

                    // Employee ID TextField
                    TextFormField(
                      controller: provider.empIDController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: provider.validateempIDTextField,
                      decoration: InputDecoration(
                        hintText: 'Employee ID',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password TextField
                    TextFormField(
                      obscureText: _obscureText,
                      controller: provider.passwordController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: provider.validatepasswordTextField,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFF5F7FA),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 1.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgetScreen()),
                          );
                        },
                        child: const Text(
                          'Forget Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Log In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25507C),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
      ),
    );
  }
}
