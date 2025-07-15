class ModuleModel {
  final int value;
  final String text;

  ModuleModel({required this.value, required this.text});

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      value: json['Value'],
      text: json['Text'],
    );
  }
}
