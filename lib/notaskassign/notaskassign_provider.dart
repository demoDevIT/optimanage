import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/UtilityClass.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/colors.dart';
import 'package:optimanage/constant/Constants.dart';
//import 'timesheet_provider.dart'; // If fetchTimesheetData is in there

class NoTaskAssignProvider extends ChangeNotifier {
  int taskHour = 0;
  int taskMinute = 0;

  void calculateTaskDuration(TimeOfDay? start, TimeOfDay? end) {
    if (start == null || end == null) return;

    final now = DateTime.now();
    final startDateTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    final endDateTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);

    final duration = endDateTime.difference(startDateTime);

    if (duration.inMinutes < 0) {
      taskHour = 0;
      taskMinute = 0;
    } else {
      taskHour = duration.inHours;
      taskMinute = duration.inMinutes % 60;
    }

    notifyListeners();
  }

  bool isLoading = false;

  Future<void> submitNoTask({
    required BuildContext context,
    required String description,
    required String startTime,
    required String endTime,
    required int taskHour,
    required int taskMinutes,
    required int userId,
    required String entryDate,
    required int taskDuration,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      int taskDuration = taskHour * 60 + taskMinutes;

      final body = {
        "TaskType": 3,
        "TaskId": 0,
        "TaskDescription": description,
        "TaskStatus": 0,
        "EntryDate": entryDate,
        "TaskHour": taskHour,
        "TaskMinutes": taskMinutes,
        "TaskDuration": taskDuration,
        "StartTime": startTime,
        "EndTime": endTime,
        "ProjectId": 0,
        "TaskTypeId": 0,
        "ModuleId": 0,
        "UserId": userId,
      };

      HttpService http = HttpService(Constants.baseurl);
      final response = await http.postRequest("/api/Timesheet/CreateTimesheet", body);

      final success = response.data['State'] == 1;
      final message = response.data['Message'] ?? "Submission successful";

      if (success) {
        UtilityClass.showSnackBar(context, message, Colors.green);
        Navigator.pop(context, true);
      } else {
        UtilityClass.showSnackBar(context, response.data['ErrorMessage'], Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Submit error: $e");
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }
}
