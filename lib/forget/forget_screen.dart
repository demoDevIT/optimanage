import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard on outside tap
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 101), // 👈 Top margin
                child: Image.asset(
                  'assets/logos/logo.png',
                  width: 105,
                  height: 110,
                ),
              ),

              // Image.asset(
              //   'assets/logos/logo.png',
              //   height: 80,
              // ),

              const SizedBox(height: 32),

              // Forget Password Heading and Text (as image)
              Image.asset(
                'assets/logos/forget.png',
                height: 90,
              ),

              const SizedBox(height: 32),

              // Email Input Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Your Email *',
                    //hintStyle: TextStyle(color: Colors.grey),
                    // hintStyle: TextStyle(
                    //   color: Color(0xF5F9FE), // Custom gray
                    //   fontWeight: FontWeight.w500,
                    //   fontSize: 14,
                    // ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Send Link Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your "send reset link" logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25507C),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Send Link',
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
        ),
      ),
    ),
    );
  }
}
