import 'dart:convert';
import 'package:flutter/material.dart';

import '../RD/project_model.dart';
import '../RD/module_model.dart';
import '../utils/PrefUtil.dart';
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

      HttpService http = HttpService(Constants.baseurl,context);

      final int userId = await PrefUtil.getPrefUserId() ?? 0;
      final int roleId = await PrefUtil.getRoleId() ?? 0; // fallback if null

      Map<String, dynamic> body = {
        "UserId": userId,
        "RoleId": roleId,
        "ProjectId": 0,
        "ModuleId": 0,
      };

      print("✅ RD Project List Request: ${body}");

      final response = await http.postRequest("/api/Dropdown/GetProjectList", body);

      print("✅ Project List Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _projects = list.map((e) => ProjectModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        print("❌ No projects found.");
      }
    } catch (e) {
      print("❌ Error fetching projects: $e");
      UtilityClass.askForInput('Error', 'Failed to load project list.', 'OK', '', true);
    }
  }

  /// Get Module List by ProjectId
  Future<void> fetchModuleList(BuildContext context, int projectId) async {
    try {

      HttpService http = HttpService(Constants.baseurl,context);

      final int userId = await PrefUtil.getPrefUserId() ?? 0;
      final int roleId = await PrefUtil.getRoleId() ?? 0; // fallback if null

      Map<String, dynamic> body = {
        "UserId": userId,
        "RoleId": roleId,
        "ProjectId": projectId,
        "ModuleId": 0,
      };

      print("✅ RD Module List Request: ${body}");

      final response = await http.postRequest("/api/Dropdown/GetModuleList", body);

      print("✅ Module List Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _modules = list.map((e) => ModuleModel.fromJson(e)).toList();
        notifyListeners();
      } else {
        print("❌ No modules found.");
      }
    } catch (e) {
      print("❌ Error fetching modules: $e");
      UtilityClass.askForInput('Error', 'Failed to load module list.', 'OK', '', true);
    }
  }

  List<ModuleModel> _subModules = [];
  List<ModuleModel> get subModules => _subModules;

  Future<void> fetchSubModuleList(BuildContext context, int moduleId, int projectId) async {
    try {

      HttpService http = HttpService(Constants.baseurl,context);

      final int userId = await PrefUtil.getPrefUserId() ?? 0;
      final int roleId = await PrefUtil.getRoleId() ?? 0; // fallback if null

      Map<String, dynamic> body = {
        "UserId": userId,
        "RoleId": roleId,
        "ProjectId": projectId,
        "ModuleId": moduleId,
      };

      print("✅ RD SUB-Module List Request: ${body}");

      final response = await http.postRequest("/api/Dropdown/GetSubModuleList", body);

      print("✅ Submodule Response: ${response.data}");

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _subModules = list.map((e) => ModuleModel.fromJson(e)).toList();
      } else {
        _subModules = []; // clear list to hide dropdown
      }

      notifyListeners();
    } catch (e) {
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

      HttpService http = HttpService(Constants.baseurl,context);
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
