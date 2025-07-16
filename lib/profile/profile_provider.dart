// profile_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import '../profile/profile_model.dart';// Adjust path accordingly
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import '../utils/UtilityClass.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;

  ProfileModel? get profile => _profile;

  Future<void> fetchProfile(BuildContext context) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Profile...');
      HttpService http = HttpService(Constants.baseurl);

      final Map<String, dynamic> body = {
        "UserId": 55, // Replace with actual user ID
      };

      final response = await http.postRequest("/api/Employee/GetEmployeeProfile", body);
      UtilityClass.dismissProgressDialog();

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
      UtilityClass.dismissProgressDialog();
      print("❌ Error fetching profile: $e");
      UtilityClass.askForInput('Error', 'Failed to load profile.', 'OK', '', true);
    }
  }
}
