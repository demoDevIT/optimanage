class AssignedTaskModel {
  final int projectId;
  final int moduleId;
  final int taskIssueID;
  final String projectName;
  final String moduleName;
  final String taskName;
  final String taskDescription;
  final String taskStartDate;
  final String taskEndDate;
  final String taskStatus;
  final String taskType;

  AssignedTaskModel({
    required this.projectId,
    required this.moduleId,
    required this.taskIssueID,
    required this.projectName,
    required this.moduleName,
    required this.taskName,
    required this.taskDescription,
    required this.taskStartDate,
    required this.taskEndDate,
    required this.taskStatus,
    required this.taskType,
  });

  factory AssignedTaskModel.fromJson(Map<String, dynamic> json) {
    return AssignedTaskModel(
      projectId: json['ProjectId'],
      moduleId: json['ModuleId'],
      taskIssueID: json['TaskIssueID'],
      projectName: json['ProjectName'],
      moduleName: json['ModuleName'],
      taskName: json['TaskName'],
      taskDescription: json['TaskDescription'],
      taskStartDate: json['Task_StartDate'],
      taskEndDate: json['Task_EndDate'],
      taskStatus: json['TaskStatus'],
      taskType: json['TaskType'],
    );
  }
}
