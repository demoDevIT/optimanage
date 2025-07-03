class TaskSummaryModalPopup {
  final String projectName;
  final String employeeName;
  final int totalTasks;
  final int completedTasks;
  final String estimateTaskDuration;
  final String utilizedDuration;
  final String completionRate;
  final int pendingTasks;
  final String taskQuality;
  final String avgTaskDuration;
  final String taskQualityColor;

  TaskSummaryModalPopup({
    required this.projectName,
    required this.employeeName,
    required this.totalTasks,
    required this.completedTasks,
    required this.estimateTaskDuration,
    required this.utilizedDuration,
    required this.completionRate,
    required this.pendingTasks,
    required this.taskQuality,
    required this.avgTaskDuration,
    required this.taskQualityColor,
  });

  factory TaskSummaryModalPopup.fromJson(Map<String, dynamic> json) {
    return TaskSummaryModalPopup(
      projectName: json["ProjectName"],
      employeeName: json["EmployeeNameEn"],
      totalTasks: json["TotalTasks"],
      completedTasks: json["CompletedTasks"],
      estimateTaskDuration: json["EstimateTaskDuration"],
      utilizedDuration: json["UtilizedDuration"],
      completionRate: json["CompletionRate"],
      pendingTasks: json["PendingTasks"],
      taskQuality: json["TaskQuality"],
      avgTaskDuration: json["AvgTaskDuration"],
      taskQualityColor: json["TaskQualityColor"],
    );
  }
}
