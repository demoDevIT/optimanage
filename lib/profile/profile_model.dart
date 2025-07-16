class ProfileModel {
  final String EmployeeNameEn;
  final String EmployeeCode;
  final String UserImagePath;
  final String RoleName;
  //final String employeeType;

  ProfileModel({
    required this.EmployeeNameEn,
    required this.EmployeeCode,
    required this.UserImagePath,
    required this.RoleName,
    //required this.employeeType,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      EmployeeNameEn: json['EmployeeNameEn'] ?? '',
      EmployeeCode: json['EmployeeCode']?.toString() ?? '',
      UserImagePath: json['UserImagePath']?.toString() ?? '',
      RoleName: json['RoleName']?.toString() ?? '',
      //employeeType: json['EmployeeType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeNameEn': EmployeeNameEn,
      'EmployeeCode': EmployeeCode,
      'UserImagePath': UserImagePath,
      'RoleName': RoleName,
      //'EmployeeType': employeeType,
    };
  }
}
