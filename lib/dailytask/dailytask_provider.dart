import 'dart:convert';
import 'package:flutter/material.dart';
import '../utils/UtilityClass.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';

class DailyTaskProvider with ChangeNotifier {
  List<DropdownMenuItem<String>> _statusList = [];

  List<DropdownMenuItem<String>> get statusList => _statusList;

  Future<void> fetchTaskStatusList(BuildContext context) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Task Status...');

      HttpService http = HttpService(Constants.baseurl);

      // ✅ POST with empty body
      final response = await http.postRequest("/api/Dropdown/GetDailyTaskStatusList", {});

      UtilityClass.dismissProgressDialog();

      print("✅ Task Status Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _statusList = list.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem<String>(
            value: e['Value'].toString(), // value = status ID
            child: Text(e['Text']),       // display text
          );
        }).toList();

        notifyListeners();
      } else {
        print("❌ Task Status load failed or empty.");
        UtilityClass.askForInput('No Data', 'Task status list is empty.', 'OK', '', true);
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Error fetching task status: $e");
      UtilityClass.askForInput('Error', 'Failed to load task status.', 'OK', '', true);
    }
  }
}
