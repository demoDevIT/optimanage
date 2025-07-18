import 'package:intl/intl.dart';

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
    String formatActionDate(String? rawDate) {
      if (rawDate == null || rawDate.isEmpty) return '';
      try {
        final parsedDate = DateTime.parse(rawDate);
        return DateFormat('dd-MM-yyyy').format(parsedDate);
      } catch (e) {
        return rawDate; // fallback to original if parsing fails
      }
    }

    return TaskSummary(
      projectName: json['ProjectName'] ?? '',
      createdDate: json['CreatedOn'] ?? '',
      estimateTime: json['EstimateTime'] ?? '',
      actionDate: formatActionDate(json['TaskCompleteDate']),
      moduleName: json['ModuleName'] ?? '',
      description: json['TaskDesc'] ?? '',
    );
  }
}
