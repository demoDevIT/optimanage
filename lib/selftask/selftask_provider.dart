import 'dart:convert';
import 'package:flutter/material.dart';
import '../selftask/project_model.dart';
import '../selftask/module_model.dart';
import '../selftask/task_type_model.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import '../utils/UtilityClass.dart';

class SelfTaskProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  List<ModuleModel> _modules = [];
  List<TaskTypeModel> _taskTypes = [];

  int? selectedProjectId;
  int? selectedModuleId;
  int? selectedTaskTypeId;

  List<ProjectModel> get projects => _projects;
  List<ModuleModel> get modules => _modules;
  List<TaskTypeModel> get taskTypes => _taskTypes;

  /// Fetch Projects
  Future<void> fetchProjectList(BuildContext context) async {
    try {
      UtilityClass.showProgressDialog(context, 'Fetching Projects...');
      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "UserId": 55,
        "RoleId": 4,
        "ProjectId": 0,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetProjectList", body);
      UtilityClass.dismissProgressDialog();

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _projects = list.map((e) => ProjectModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      UtilityClass.askForInput('Error', 'Failed to load project list.', 'OK', '', true);
    }
  }

  /// Fetch Modules
  Future<void> fetchModuleList(BuildContext context, int projectId) async {
    selectedModuleId = null;
    selectedTaskTypeId = null;
    _modules = [];
    _taskTypes = [];
    notifyListeners();

    try {
      UtilityClass.showProgressDialog(context, 'Fetching Modules...');
      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": projectId,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetModuleList", body);
      UtilityClass.dismissProgressDialog();

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _modules = list.map((e) => ModuleModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      UtilityClass.askForInput('Error', 'Failed to load module list.', 'OK', '', true);
    }
  }

  /// Fetch Task Types
  Future<void> fetchTaskTypeList(BuildContext context, int projectId, int moduleId) async {
    selectedTaskTypeId = null;
    _taskTypes = [];
    notifyListeners();

    try {
      UtilityClass.showProgressDialog(context, 'Fetching Task Types...');
      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": projectId,
        "ModuleId": moduleId,
      };

      final response = await http.postRequest("/api/Dropdown/GetTaskTypeList", body);
      UtilityClass.dismissProgressDialog();

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _taskTypes = list.map((e) => TaskTypeModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      UtilityClass.askForInput('Error', 'Failed to load task type list.', 'OK', '', true);
    }
  }

  void setSelectedProject(int? id) {
    selectedProjectId = id;
    notifyListeners();
  }

  void setSelectedModule(int? id) {
    selectedModuleId = id;
    notifyListeners();
  }

  void setSelectedTaskType(int? id) {
    selectedTaskTypeId = id;
    notifyListeners();
  }
}
