import 'AssignedTaskModel.dart';

class AssignedProjectModel {
  final String projectName;
  final List<AssignedTaskModel> taskData;

  AssignedProjectModel({
    required this.projectName,
    required this.taskData,
  });

  factory AssignedProjectModel.fromJson(Map<String, dynamic> json) {
    return AssignedProjectModel(
      projectName: json['ProjectName'],
      taskData: (json['TaskData'] as List)
          .map((taskJson) => AssignedTaskModel.fromJson(taskJson))
          .toList(),
    );
  }
}
