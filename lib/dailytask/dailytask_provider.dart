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

  Future<void> submitDailyTask({
    required BuildContext context,
    required String description,
    required String startTime,
    required String endTime,
    required int taskHour,
    required int taskMinutes,
    required int taskStatus,
    required int projectId,
    required int userId,
    required int moduleId,
  }) async {
    try {
      UtilityClass.showProgressDialog(context, 'Submitting Daily Task...');

      final now = DateTime.now();
      final entryDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final taskDuration = (taskHour * 60) + taskMinutes;

      final body = {
        "TaskType": 1,
        "TaskId": 0,
        "TaskDescription": description,
        "TaskStatus": taskStatus,
        "EntryDate": entryDate,
        "TaskHour": taskHour,
        "TaskMinutes": taskMinutes,
        "TaskDuration": taskDuration,
        "StartTime": startTime,
        "EndTime": endTime,
        "ProjectId": projectId,
        "TaskTypeId": 0,
        "ModuleId": moduleId,
        "UserId": userId,
      };

      print('📤 Sending Timesheet data: $body');

      HttpService http = HttpService(Constants.baseurl);
      final response = await http.postRequest("/api/Timesheet/CreateTimesheet", body);

      UtilityClass.dismissProgressDialog();

      final success = response.data['State'] == 1;
      final message = response.data['Message'] ?? "Submission successful";

      if (success) {
        UtilityClass.showSnackBar(context, message, Colors.green);
        Navigator.pop(context, true);
      } else {
        UtilityClass.showSnackBar(context, message, Colors.red);
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      debugPrint("❌ Submit error: $e");
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
    }
  }

}
