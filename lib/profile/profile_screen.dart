import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../SignIn/SignInScreen.dart';
import '../constant/common.dart';
import 'package:optimanage/profile/profile_provider.dart';
import 'package:optimanage/profile/change_password_dialog.dart';

import '../main.dart';
import '../utils/PrefUtil.dart';
import '../utils/RightToLeftRoute.dart';
import '../utils/UtilityClass.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    // Call fetchProfile when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: common.Appbar(
        title: "Profile",
        callback: () => Navigator.of(context).pop(false),
         actions: [
          // SvgPicture.asset(
          //   'assets/icons/notification.svg',
          //   width: 24,
          //   height: 24,
          // ),
          const SizedBox(width: 60),
         ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: profile == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: profile.UserImagePath != null && profile.UserImagePath.isNotEmpty
                      ? Image.network(
                    profile.UserImagePath,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/logos/avatar2.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/logos/avatar2.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildReadOnlyField(profile.EmployeeNameEn, "Name"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.EmployeeCode, "Emp Code"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.MobileNumber, "Mobile"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.Email, "Email"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.DOB, "Date of Birth"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.Gender, "Gender"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.DOJ, "Date of Joining"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.ExpYear, "Exp Year"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.Designation, "Designation"),
            const SizedBox(height: 16),
            _buildReadOnlyField(profile.RoleName, "Role"),
            const SizedBox(height: 30),
            _buildButtons(context),
          ],
        ),
      ),
      ),
     // bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildReadOnlyField(String value, labelName) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: labelName, // 👈 Label name at top-left inside border
        labelStyle: const TextStyle(
          color: Color(0xFF6E6A7C),
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        filled: true,
        fillColor: const Color(0xFFF3F7FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF6E6A7C),
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              bool check = await UtilityClass.askForInput(
                "Logout",
                "Are you sure you want to logout?",
                "Logout", // Red button
                "Cancel", // Outline button
                false,    // Show both buttons
              );

              if (check) {
                print("✅ Logout button pressed");
                await PrefUtil.setUserLoggedWay("false");
                await PrefUtil.clearAll();

                navigatorKey.currentState?.pushReplacement(
                  RightToLeftRoute(
                    page: SignInScreen(),
                    duration: const Duration(milliseconds: 500),
                    startOffset: const Offset(-1.0, 0.0),
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: Color(0xFF25507C), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF25507C),
              ),
            ),
          ),

        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () => showChangePasswordDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25507C),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 3,
      onTap: (index) {
        // Handle navigation
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }

  void showChangePasswordDialog(BuildContext context) async {
    final userId = await PrefUtil.getPrefUserId(); // 👈 Fetch dynamic ID

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Change Password",
      pageBuilder: (context, _, __) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, _, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: ChangePasswordDialog(userId: userId!), // 👈 Set dynamically
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

}

void showLogoutDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "Logout",
    pageBuilder: (context, _, __) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, _, child) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Opacity(
          opacity: animation.value,
          child: Center(
            child: AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/logos/logout.png',
                    width: 48,
                    height: 48,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Are you sure you want to log out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Color(0xFF25507C)),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF25507C),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Perform logout
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25507C),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}