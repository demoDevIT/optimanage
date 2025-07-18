class TaskTypeModel {
  final int id;
  final String name;

  TaskTypeModel({required this.id, required this.name});

  factory TaskTypeModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeModel(
      id: json['FieldId'],
      name: json['FieldName'],
    );
  }
}
