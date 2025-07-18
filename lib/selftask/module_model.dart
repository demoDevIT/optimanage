class ModuleModel {
  final int id;
  final String name;

  ModuleModel({required this.id, required this.name});

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['Value'],
      name: json['Text'],
    );
  }
}
