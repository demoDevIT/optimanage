import 'package:flutter/material.dart';
import 'package:optimanage/utils/UtilityClass.dart';
import 'package:provider/provider.dart';
import '../SignIn/SignInScreen.dart';
import '../main.dart';
import '../profile/profile_screen.dart';
import '../timesheet/timesheet_screen.dart';
import '../utils/PrefUtil.dart';
import '../utils/RightToLeftRoute.dart';
import 'home_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      drawer:  AppDrawer(),
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon:
            // Image.asset(
            //   'assets/icons/dashboard_menu.png',
            //   width: 24,
            //   height: 24,
            // ),
            SvgPicture.asset(
              'assets/icons/dashboard_menu.svg',
              width: 18,
              height: 18,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
                // );
              },
              child:
              // Image.asset(
              //   'assets/icons/notification.png',
              //   //for new notifications (with dot)
              //   //'assets/icons/notify.png', // for no notifications (without dot)
              //   width: 24, // optional: set width
              //   height: 24, // optional: set height
              // ),

              SvgPicture.asset(
                'assets/icons/notification.svg',
                width: 24,
                height: 24,
              ),

            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Banner (white background)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/logos/dashboard.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ✅ Expanded section with blue background from Dashboard title to bottom
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F4FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _dashboardCard(
                      imagePath: 'assets/icons/dailyTmsht.svg',
                      title: 'Daily Timesheets',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  TimeSheetScreen(status:"daily"),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _dashboardCard(
                      imagePath: 'assets/icons/leave.svg',
                      title: 'Leave',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  TimeSheetScreen(status:"live"),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),


    );
  }

  Widget _dashboardCard({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SvgPicture.asset(
                  imagePath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showLogoutDialog(BuildContext context, HomeProvider provider) {
  print("🔔 Logout dialog triggered");

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog first

            },
          ),

        ],
      );
    },
  );
}

class AppDrawer extends StatefulWidget {
  AppDrawer({key}):super();
  _AppDrawer createState() => _AppDrawer();

}

class _AppDrawer extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _loadUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final userInfo = snapshot.data ?? {
          'NameEn': 'User name',
          'UserEmail': 'yourmail@gmail.com',
          'UserImagePath': ''
        };

        return Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                /// 👤 Top user header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      /// 👤 Avatar
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundImage: userInfo['UserImagePath'] != null &&
                              userInfo['UserImagePath']!.isNotEmpty
                              ? NetworkImage(userInfo['UserImagePath']!)
                          as ImageProvider
                              : const AssetImage('assets/logos/avatar.png'),
                        ),
                      ),
                      const SizedBox(width: 12),

                      /// 🧑 Username + Email
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userInfo['NameEn'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userInfo['UserEmail'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(),

                /// Drawer items
                drawerItem(
                  'assets/icons/dashboard.svg',
                  'Daily Timesheets',
                  context,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TimeSheetScreen(status: "daily"),
                      ),
                    );
                  },
                ),
                drawerItem('assets/icons/project.svg', 'Leave', context, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimeSheetScreen(status: "live"),
                    ),
                  );
                }),
                ListTile(
                  // leading: Image.asset('assets/icons/recruit.svg',
                  //     width: 24, height: 24),
                  leading: SvgPicture.asset(
                    'assets/icons/recruit.svg',
                    width: 25,
                    height: 25,
                  ),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  // leading: Image.asset('assets/icons/logout.svg',
                  //     width: 24, height: 24),
                  leading: SvgPicture.asset(
                    'assets/icons/logout.svg',
                    width: 25,
                    height: 25,
                  ),
                  title: const Text('Logout'),
                  onTap: () async {
                    Navigator.pop(context);
                    bool check = await UtilityClass.askForInput(
                      "Logout",
                      "Are you sure you want to logout?",
                      "Logout",
                      "Cancel",
                      false,
                    );
                    if (check) {
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget drawerItem(String imagePath, String title, BuildContext context, VoidCallback onTap) {
    return ListTile(
      leading:
      SvgPicture.asset(
        imagePath,
        width: 18,
        height: 18,
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}

Future<Map<String, String?>> _loadUserInfo() async {
  return {
    'NameEn': await PrefUtil.getNameEn(),
    'UserEmail': await PrefUtil.getUserEmail(),
    'UserImagePath': await PrefUtil.getUserImagePath(),
  };
}
