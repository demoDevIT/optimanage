import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
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

  List<PlatformFile> selectedFiles = []; // ✅ multiple file support
  List<String> uploadedFilePaths = []; // ✅ store uploaded file paths

  void clearFiles() {
    selectedFiles.clear();
    uploadedFilePaths.clear();
    notifyListeners();
  }

  /// Fetch Projects
  Future<void> fetchProjectList(BuildContext context) async {
    try {
      HttpService http = HttpService(Constants.baseurl,context);

      final body = {
        "UserId": 55,
        "RoleId": 4,
        "ProjectId": 0,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetProjectList", body);

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _projects = list.map((e) => ProjectModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
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
      HttpService http = HttpService(Constants.baseurl,context);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": projectId,
        "ModuleId": 0,
      };

      final response = await http.postRequest("/api/Dropdown/GetModuleList", body);

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _modules = list.map((e) => ModuleModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.askForInput('Error', 'Failed to load module list.', 'OK', '', true);
    }
  }

  Future<void> fetchSubModuleList(BuildContext context, int moduleId) async {
    selectedSubModuleId = null;
    _subModules = [];
    notifyListeners();

    try {
      HttpService http = HttpService(Constants.baseurl,context);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": 0,
        "ModuleId": moduleId,
      };

      final response = await http.postRequest("/api/Dropdown/GetSubModuleList", body);

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _subModules = list.map((e) => ModuleModel.fromJson(e)).toList();
      } else {
        _subModules = [];
      }

      notifyListeners();
    } catch (e) {
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
      HttpService http = HttpService(Constants.baseurl,context);

      final body = {
        "UserId": 0,
        "RoleId": 0,
        "ProjectId": projectId,
        "ModuleId": moduleId,
      };

      final response = await http.postRequest("/api/Dropdown/GetTaskTypeList", body);

      if (response.data["Status"] == true && response.data["Result"] != null) {
        final List<dynamic> list = jsonDecode(response.data["Result"]);
        _taskTypes = list.map((e) => TaskTypeModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      UtilityClass.askForInput('Error', 'Failed to load task type list.', 'OK', '', true);
    }
  }

  Future<void> pickDocuments(BuildContext context) async {
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
                selectedFiles.add(PlatformFile(
                  name: picked.name,
                  path: picked.path,
                  size: File(picked.path).lengthSync(),
                ));
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
                allowMultiple: true,
                allowedExtensions: ['pdf', 'jpg', 'png', 'doc', 'docx', 'jpeg'],
              );
              if (result != null && result.files.isNotEmpty) {
                selectedFiles.addAll(result.files);
                notifyListeners();
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> uploadFiles(BuildContext context) async {
    uploadedFilePaths.clear();

    HttpService http = HttpService(Constants.baseurl,context);

    for (var file in selectedFiles) {
      final filePath = file.path;
      if (filePath == null) {
        print("⚠️ File path is null for file: ${file.name}");
        continue;
      }

      // ⬇️ Debug: print file info before uploading
      final fileObject = File(filePath);
      final fileExists = await fileObject.exists();
      final fileSize = await fileObject.length();

      print("📁 Uploading File: ${file.name}");
      print("📍 File path: $filePath");
      print("✅ File exists: $fileExists");
      print("📏 File size: $fileSize bytes");

      if (!fileExists || fileSize == 0) {
        print("🚫 Skipping upload: File is missing or empty.");
        continue;
      }

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      print("📤 Sending FormData: $formData");

      final response = await http.MultipartFilePostRequest(
        "/api/Timesheet/UploadFiles",
        formData,
      );

      print("✅ Upload response: ${response}");

      // ✅ Correct way to extract and convert the file path
      String fullPath = response.data['FilePath'] ?? '';
      if (fullPath.isNotEmpty) {
        String fileName = fullPath.split('\\').last;
        String urlPath = 'https://optimanageapi.devitsandbox.com/StaticFiles/$fileName';
        uploadedFilePaths.add(urlPath);
      }
      debugPrint("📂 Uploaded File URLs: $uploadedFilePaths");

    }
  }


  bool isLoading = false;

  // update submit task method to include TaskDocuments
  Future<bool> submitSelfTask({
    required BuildContext context,
    required int projectId,
    required int moduleId,
    required int taskTypeId,
    required String taskName,
    required String taskDescription,
    required int userId,
    required String startDate,
    required String endDate,
    required int taskDuration,
    String notes = '',
    String remarks = '',
    int isHigherPriority = 0,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await uploadFiles(context); // 🚀 Upload files first

      List<Map<String, dynamic>> documents = uploadedFilePaths.map((path) => {
        "TaskId": 0,
        "DocPath": path,
        "UserId": userId
      }).toList();

      print("✅ upload file documents: ${documents}");

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
        "Remarks": remarks,
        "IsHigherPriority": isHigherPriority,
        "TaskDocuments": documents, // ✅ New field
      };

      HttpService http = HttpService(Constants.baseurl,context);
      final response = await http.postRequest("/api/Timesheet/AddSelfTask", body);

      final success = response.data['State'] == 1;
      final message = response.data['Message'] ?? 'Task submitted successfully';

      if (success) {
        UtilityClass.showSnackBar(context, message, Colors.green);
        Navigator.pop(context, true);
        return true;
      } else {
        UtilityClass.showSnackBar(context, message, Colors.red);
        return false;
      }
    } catch (e) {
      debugPrint("❌ Submit Error: $e");
      UtilityClass.showSnackBar(context, "Something went wrong", Colors.red);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearSelections() {
    selectedProjectId = null;
    selectedModuleId = null;
    selectedSubModuleId = null;
    selectedTaskTypeId = null;
    selectedFiles.clear();
    uploadedFilePaths.clear();
    notifyListeners();
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
