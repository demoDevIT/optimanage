class ProfileModel {
  final String EmployeeNameEn;
  final String EmployeeCode;
  final String MobileNumber;
  final String Email;
  final String DOB;
  final String Gender;
  final String DOJ;
  final String ExpYear;
  final String Designation;
  final String UserImagePath;
  final String RoleName;
  //final String employeeType;

  ProfileModel({
    required this.EmployeeNameEn,
    required this.EmployeeCode,
    required this.MobileNumber,
    required this.Email,
    required this.DOB,
    required this.Gender,
    required this.DOJ,
    required this.ExpYear,
    required this.Designation,
    required this.UserImagePath,
    required this.RoleName,
    //required this.employeeType,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      EmployeeNameEn: json['EmployeeNameEn'] ?? '',
      EmployeeCode: json['EmployeeCode']?.toString() ?? '',
      MobileNumber: json['Mobile']?.toString() ?? '',
      Email: json['Email']?.toString() ?? '',
      DOB: json['DOB']?.toString() ?? '',
      Gender: json['Gender']?.toString() ?? '',
      DOJ: json['DateOfJoining']?.toString() ?? '',
      ExpYear: json['Experience']?.toString() ?? '',
      Designation: json['Designation']?.toString() ?? '',
      UserImagePath: json['UserImagePath']?.toString() ?? '',
      RoleName: json['RoleName']?.toString() ?? '',
      //employeeType: json['EmployeeType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeNameEn': EmployeeNameEn,
      'EmployeeCode': EmployeeCode,
      'MobileNumber': MobileNumber,
      'Email': Email,
      'DOB': DOB,
      'Gender': Gender,
      'DOJ': DOJ,
      'ExpYear': ExpYear,
      'Designation': Designation,
      'UserImagePath': UserImagePath,
      'RoleName': RoleName,
      //'EmployeeType': employeeType,
    };
  }
}
