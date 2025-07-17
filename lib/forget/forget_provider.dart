import 'dart:convert';
import 'package:flutter/material.dart';
import '../profile/change_password_dialog.dart';
import '../services/HttpService.dart';
import '../constant/Constants.dart';
import '../utils/UtilityClass.dart';
import 'dart:ui';

class ForgetProvider with ChangeNotifier {
  Future<void> authenticateEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      UtilityClass.showProgressDialog(context, "Checking email...");
      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "Email": email,
      };

      final response = await http.postRequest("/api/Employee/GetEmailAuthenticate", body);
      UtilityClass.dismissProgressDialog();

      if (response.data['Status'] == true) {
        final resultString = response.data['Result'];

        if (resultString != null) {
          final List<dynamic> resultList = json.decode(resultString);

          if (resultList.isNotEmpty) {
            final user = resultList[0];
            final userId = user['EmployeeId'];

            if (userId != null) {
              showChangePasswordDialog(context, userId); // ✅ pass userId
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Employee ID not found.")),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Result list is empty.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Result is null.")),
          );
        }
      } else {
        final error = response.data['Message'] ?? "Authentication failed";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }

    } catch (e) {
      UtilityClass.dismissProgressDialog();
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
      print("❌ Error in authenticateEmail: $e");
    }
  }

  void showChangePasswordDialog(BuildContext context, int userId) {
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
              child: ChangePasswordDialog(userId: userId),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }


}
