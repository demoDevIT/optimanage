import 'package:flutter/material.dart';
import '../utils/UtilityClass.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePasswordDialog extends StatefulWidget {
  final int userId; // Pass user ID here

  const ChangePasswordDialog({super.key, required this.userId});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _message;

  Future<void> _changePassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    setState(() => _message = null);

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => _message = 'Please fill in both fields.');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => _message = 'Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      HttpService http = HttpService(Constants.baseurl,context);

      Map<String, dynamic> body = {
        'Password': newPassword,
        'UserId': widget.userId,
      };

      print("✅ change password Request: ${body}");

      final response = await http.postRequest("/api/Employee/GetResetPassword", body);

      if (response.data["Status"] == true) {
        setState(() {
          _message = response.data["Message"] ?? "Password changed successfully!";
        });

        await Future.delayed(const Duration(seconds: 1));
        Navigator.of(context).pop(); // Close popup
      } else {
        setState(() => _message = response.data['Message'] ?? 'Failed to change password.');
      }


    } catch (e) {
      setState(() => _message = 'Something went wrong. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(20),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Change Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              hintText: 'New password',
              filled: true,
              fillColor: const Color(0xFFF3F7FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                }),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                  // Image.asset(
                  //   _obscureNewPassword
                  //       ? 'assets/icons/eyeOn.svg'
                  //       : 'assets/icons/eyeOff.svg',
                  //   width: 24,
                  //   height: 24,
                  //   fit: BoxFit.contain,
                  // ),
                  SvgPicture.asset(
                    _obscureNewPassword
                        ? 'assets/icons/eyeOn.svg'
                        : 'assets/icons/eyeOff.svg',
                    width: 17,
                    height: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              filled: true,
              fillColor: const Color(0xFFF3F7FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: GestureDetector(
                onTap: () => setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                }),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                  // Image.asset(
                  //   _obscureConfirmPassword
                  //       ? 'assets/icons/eyeOn.svg'
                  //       : 'assets/icons/eyeOff.svg',
                  //   width: 24,
                  //   height: 24,
                  //   fit: BoxFit.contain,
                  // ),

                  SvgPicture.asset(
                    _obscureConfirmPassword
                        ? 'assets/icons/eyeOn.svg'
                        : 'assets/icons/eyeOff.svg',
                    width: 17,
                    height: 17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 🔔 Message display section
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _message!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),

          ElevatedButton(
            onPressed: _isLoading ? null : _changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25507C),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
              'Submit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),

      ),
    );
  }
}
