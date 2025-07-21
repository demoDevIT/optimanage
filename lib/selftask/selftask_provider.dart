import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../selftask/project_model.dart';
import '../selftask/module_model.dart';
import '../selftask/task_type_model.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import '../utils/UtilityClass.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:image_picker/image_picker.dart';

class SelfTaskProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  List<ModuleModel> _modules = [];
  List<ModuleModel> _subModules = [];
  List<TaskTypeModel> _taskTypes = [];

  int? selectedProjectId;
  int? selectedModuleId;
  int? selectedSubModuleId;
  int? selectedTaskTypeId;
  PlatformFile? selectedFile;

  List<ProjectModel> get projects => _projects;
  List<ModuleModel> get modules => _modules;
  List<ModuleModel> get subModules => _subModules;
  List<TaskTypeModel> get taskTypes => _taskTypes;
  //PlatformFile? get selectedFile => _selectedFile;

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

  Future<void> fetchSubModuleList(BuildContext context, int moduleId) async {
    selectedSubModuleId = null;
    _subModules = [];
    notifyListeners();

    try {
      UtilityClass.showProgressDialog(context, 'Fetching Submodules...');
      HttpService http = HttpService(Constants.baseurl);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": 0,
        "ModuleId": moduleId,
      };

      final response = await http.postRequest("/api/Dropdown/GetSubModuleList", body);
      UtilityClass.dismissProgressDialog();

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _subModules = list.map((e) => ModuleModel.fromJson(e)).toList();
      } else {
        _subModules = [];
      }

      notifyListeners();
    } catch (e) {
      UtilityClass.dismissProgressDialog();
      _subModules = [];
      notifyListeners();
      UtilityClass.askForInput('Error', 'Failed to load submodule list.', 'OK', '', true);
    }
  }

  void setSelectedSubModule(int? id) {
    selectedSubModuleId = id;
    notifyListeners();
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


  Future<void> pickDocument(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Capture with Camera'),
            onTap: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) {
                selectedFile = PlatformFile(
                  name: picked.name,
                  path: picked.path,
                  size: File(picked.path).lengthSync(),
                );
                notifyListeners();
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Choose from Files'),
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx'],
              );
              if (result != null && result.files.isNotEmpty) {
                selectedFile = result.files.first;
                notifyListeners();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  bool isLoading = false;

  Future<void> submitSelfTask({
    required BuildContext context,
    required int projectId,
    required int moduleId,
    required int taskTypeId,
    required String taskName,
    required String taskDescription,
    required int userId,
    required String startDate,  // Format: MM/dd/yyyy
    required String endDate,    // Format: MM/dd/yyyy
    required int taskDuration,
    String notes = '',
    String document = 'https://example.com/demo.pdf', // Demo URL
    String remarks = '',
    int isHigherPriority = 0,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "ProjectId": projectId,
        "ModuleId": moduleId,
        "TaskTypeId": taskTypeId,
        "TaskName": taskName,
        "TaskDescription": taskDescription,
        "UserId": userId,
        "StartDate": startDate,
        "EndDate": endDate,
        "TaskDuration": taskDuration,
        "Notes": notes,
        "Document": document,
        "Remarks": remarks,
        "IsHigherPriority": isHigherPriority,
      };

      print('📤 Sending Self Task Payload: $body');

      HttpService http = HttpService(Constants.baseurl);
      final response = await http.postRequest("/api/Timesheet/AddSelfTask", body);

      final success = response.data['State'] == 1;
      final message = response.data['Message'] ?? 'Task submitted successfully';

      if (success) {
        UtilityClass.showSnackBar(context, message, Colors.green);
        Navigator.pop(context, true);
      } else {
        UtilityClass.showSnackBar(context, message, Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Self Task Submit Error: $e");
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
    } finally {
      isLoading = false;
      notifyListeners();
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
