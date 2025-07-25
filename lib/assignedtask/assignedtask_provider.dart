import 'dart:convert';
import 'package:flutter/material.dart';

import '../utils/UtilityClass.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';

import '../assignedtask/AssignedTaskModel.dart';
import '../assignedtask/AssignedProjectModel.dart'; // Make sure this exists and is correctly imported

class AssignedTaskProvider with ChangeNotifier {
  List<AssignedProjectModel> _assignedProjects = [];

  List<AssignedProjectModel> get assignedProjects => _assignedProjects;

  Future<void> fetchAssignedTasks({
    required BuildContext context,
    required String fromDate,
    required String toDate,
    required int userId,
  }) async {
    try {
      UtilityClass.showProgressDialog(context, "Loading assigned tasks...");

      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "FromDate": fromDate,
        "ToDate": toDate,
        "UserId": userId,
      };

      final response = await http.postRequest("/api/Timesheet/GetAssignTaskList", body);
      UtilityClass.dismissProgressDialog();

      if (response.data['Status'] == true &&
          response.data['Data'] != null &&
          response.data['Data'].toString().isNotEmpty) {

        final List<dynamic> jsonList = jsonDecode(response.data['Data']);
        _assignedProjects = jsonList.map((e) => AssignedProjectModel.fromJson(e)).toList();
        notifyListeners();

      } else {
        _assignedProjects = [];

        // Show 'No data found' only if Data is actually empty
        UtilityClass.showSnackBar(
          context,
          'No record found.',
          Colors.red,
        );
      }


    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Error in fetchAssignedTasks: $e");
      _assignedProjects = [];
      UtilityClass.showSnackBar(context, "Something went wrong!", Colors.red);
    }
  }
}
