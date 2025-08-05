import 'package:flutter/material.dart';
import '../services/HttpService.dart';
import '../tasksummary//task_summary_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:optimanage/constant/Constants.dart';

class TaskSummaryProvider extends ChangeNotifier {
  List<TaskSummary> taskSummaries = [];
  TaskSummary? taskSummary;

  Future<void> fetchTaskSummary(int taskId, BuildContext context) async {
    try {
      HttpService http = HttpService(Constants.baseurl,context);

      final body = {
        "TaskId": taskId,
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetTaskSummaryList",
        body,
      );

      final resultString = response.data['Result'];
      print("🔁 API Raw Result: $resultString");

      if (resultString != null && resultString.isNotEmpty) {
        final List decodedList = jsonDecode(resultString);
        if (decodedList.isNotEmpty) {
          taskSummary = TaskSummary.fromJson(decodedList[0]);
          print("✅ Parsed Summary: $taskSummary");
        }
      } else {
        taskSummary = null;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching task summary: $e");
      taskSummary = null;
      notifyListeners();
    }
  }


  Future<int?> validateTimesheetEntry(DateTime date, int userId, BuildContext context) async {
    try {
      final http = HttpService(Constants.baseurl,context);
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final body = {
        "FromDate": formattedDate,
        "ToDate": formattedDate,
        "UserId": userId,
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetValidateTimesheetEntry",
        body,
      );

      final resultString = response.data['Result'];
      if (resultString != null && resultString.isNotEmpty) {
        final List<dynamic> resultList = jsonDecode(resultString);
        if (resultList.isNotEmpty) {
          return resultList[0]['NotEntryCount'];
        }
      }

      return null;
    } catch (e) {
      debugPrint("❌ Error validating timesheet entry: $e");
      return null;
    }
  }

}

