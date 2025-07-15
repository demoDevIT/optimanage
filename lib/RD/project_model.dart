class ProjectModel {
  final int fieldId;
  final String fieldName;

  ProjectModel({required this.fieldId, required this.fieldName});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      fieldId: json['FieldId'],
      fieldName: json['FieldName'],
    );
  }
}
