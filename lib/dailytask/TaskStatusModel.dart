class TaskStatusModel {
  final int id;
  final String text;

  TaskStatusModel({required this.id, required this.text});

  factory TaskStatusModel.fromJson(Map<String, dynamic> json) {
    return TaskStatusModel(
      id: int.tryParse(json['Value'].toString()) ?? 0,
      text: json['Text'] ?? '',
    );
  }
}
