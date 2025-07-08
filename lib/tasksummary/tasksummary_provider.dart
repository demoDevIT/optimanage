import 'package:flutter/material.dart';
import '../services/HttpService.dart';
import '../tasksummary//task_summary_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class TaskSummaryProvider extends ChangeNotifier {
  List<TaskSummary> taskSummaries = [];
  TaskSummary? taskSummary;

  Future<void> fetchTaskSummary(DateTime date, int userId) async {
    try {
      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

      final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final body = {
        "FromDate": "2025-06-18", //formattedDate,
        "ToDate": "2025-06-18", //formattedDate,
        "UserId": 55, //userId,
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
      taskSummaries = [];
      notifyListeners();
    }
  }
}

