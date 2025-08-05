// profile_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../profile/profile_model.dart';// Adjust path accordingly
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import '../utils/PrefUtil.dart';
import '../utils/UtilityClass.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  Future<void> fetchProfile(BuildContext context) async {
    try {
      HttpService http = HttpService(Constants.baseurl,context);

      // ✅ Dynamically get UserId from PrefUtil
      int? userId = await PrefUtil.getPrefUserId();

      if (userId == null || userId == 0) {
          print("❌ User ID not found in preferences.");
        UtilityClass.askForInput('Error', 'User ID not found.', 'OK', '', true);
        return;
      }

      final Map<String, dynamic> body = {
        "UserId": userId,
      };
      print("✅ Profile Request: ${body}");
      final response = await http.postRequest("/api/Employee/GetEmployeeProfile", body);

      print("✅ Profile Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        if (list.isNotEmpty) {
          _profile = ProfileModel.fromJson(list.first);
          notifyListeners();
        }
      } else {
        print("❌ No profile found.");
      }
    } catch (e) {
      print("❌ Error fetching profile: $e");
      UtilityClass.askForInput('Error', 'Failed to load profile.', 'OK', '', true);
    }
  }
}
