import 'dart:convert';
import 'package:flutter/material.dart';

import '../RD/project_model.dart';
import '../RD/module_model.dart';
import '../utils/UtilityClass.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';

class RdProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  List<ModuleModel> _modules = [];

  List<ProjectModel> get projects => _projects;
  List<ModuleModel> get modules => _modules;

  /// Get Project List
  Future<void> fetchProjectList(BuildContext context) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Projects...');

      HttpService http = HttpService(Constants.baseurl);

      Map<String, dynamic> body = {
        "UserId": 55,
        "RoleId": 4,
        "ProjectId": 0,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetProjectList", body);
      UtilityClass.dismissProgressDialog();

      print("✅ Project List Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _projects = list.map((e) => ProjectModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        print("❌ No projects found.");
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Error fetching projects: $e");
      UtilityClass.askForInput('Error', 'Failed to load project list.', 'OK', '', true);
    }
  }

  /// Get Module List by ProjectId
  Future<void> fetchModuleList(BuildContext context, int projectId) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Modules...');

      HttpService http = HttpService(Constants.baseurl);

      Map<String, dynamic> body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": projectId,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetModuleList", body);
      UtilityClass.dismissProgressDialog();

      print("✅ Module List Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _modules = list.map((e) => ModuleModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        print("❌ No modules found.");
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Error fetching modules: $e");
      UtilityClass.askForInput('Error', 'Failed to load module list.', 'OK', '', true);
    }
  }

  List<ModuleModel> _subModules = [];
  List<ModuleModel> get subModules => _subModules;

  Future<void> fetchSubModuleList(BuildContext context, int moduleId) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Submodules...');

      HttpService http = HttpService(Constants.baseurl);

      Map<String, dynamic> body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": 0,
        "ModuleId": moduleId,
      };

      final response = await http.postRequest("/api/Dropdown/GetSubModuleList", body);
      UtilityClass.dismissProgressDialog();

      print("✅ Submodule Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _subModules = list.map((e) => ModuleModel.fromJson(e)).toList();
      } else {
        _subModules = []; // clear list to hide dropdown
      }

      notifyListeners();
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Error fetching submodules: $e");
      _subModules = []; // fallback
      notifyListeners();
    }
  }

  bool isLoading = false;

  Future<void> submitRdTask({
    required BuildContext context,
    required String description,
    required String startTime,
    required String endTime,
    required int taskHour,
    required int taskMinutes,
    required String entryDate,
    required int taskDuration,
    required int projectId,
    required int moduleId,
    required int userId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "TaskType": 4,
        "TaskId": 0,
        "TaskDescription": description,
        "TaskStatus": 0,
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

      print('📤 Sending data to APIIIII--->: $body');

      HttpService http = HttpService(Constants.baseurl);
      final response = await http.postRequest("/api/Timesheet/CreateTimesheet", body);

      final success = response.data['State'] == 1;
        final message = response.data['Message'] ?? "Submission successful";

      if (success) {
        UtilityClass.showSnackBar(context, message, Colors.green);
        Navigator.pop(context, true);  // 👈 return success flag
      } else {
        UtilityClass.showSnackBar(context, message, Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Submit error: $e");
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
