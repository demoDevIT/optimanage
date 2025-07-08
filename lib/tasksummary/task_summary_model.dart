class TaskSummary {
  final String projectName;
  final String createdDate;
  final String estimateTime;
  final String actionDate;
  final String moduleName;
  final String description;

  TaskSummary({
    required this.projectName,
    required this.createdDate,
    required this.estimateTime,
    required this.actionDate,
    required this.moduleName,
    required this.description,
  });

  factory TaskSummary.fromJson(Map<String, dynamic> json) {
    return TaskSummary(
      projectName: json['ProjectName'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      estimateTime: json['EstimateTime'] ?? '',
      actionDate: json['Action_Date_DDMMYYYY'] ?? '',
      moduleName: json['ModuleName'] ?? '',
      description: json['IssueTaskDescription'] ?? '',
    );
  }
}
