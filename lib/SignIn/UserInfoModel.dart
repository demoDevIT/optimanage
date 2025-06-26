class UserInfoModel {
  String? UserId;
  String? TitleId;
  String? NameEn;
  String? NameHi;
  String? LoginId;
  String? LoginPassword;
  String? LoginRecoveryQuestionId;
  String? LoginRecoveryAnswer;
  String? GenderId;
  String? UserImagePath;
  String? MobileNo;
  String? LandlineNo;
  String? UserEmail;
  String? UserAddressEn;
  String? Address;
  String? LastLoginDateTime;
  String? LastLoginAttemptDateTime;
  String? NoOfAttempt;
  String? IsFirstTimeLogin;
  String? LastLoginAttemptTempDateTime;
  String? UserDeactiveDateTime;
  String? WebsiteId;
  String? IsUserActive;
  String? IsUserDelete;
  String? CreateBy;
  String? CreateDateTime;
  String? UpdateBy;
  String? UpdateDateTime;
  String? RoleId;
  String? RoleNameEn;
  String? IsResetPassword;

  UserInfoModel(
      {this.UserId,
        this.TitleId,
        this.NameEn,
        this.NameHi,
        this.LoginId,
        this.LoginPassword,
        this.LoginRecoveryQuestionId,
        this.LoginRecoveryAnswer,
        this.GenderId,
        this.UserImagePath,
        this.MobileNo,
        this.LandlineNo,
        this.UserEmail,
        this.UserAddressEn,
        this.Address,
        this.LastLoginDateTime,
        this.LastLoginAttemptDateTime,
        this.NoOfAttempt,
        this.IsFirstTimeLogin,
        this.LastLoginAttemptTempDateTime,
        this.UserDeactiveDateTime,
        this.WebsiteId,
        this.IsUserActive,
        this.IsUserDelete,
        this.CreateBy,
        this.CreateDateTime,
        this.UpdateBy,
        this.UpdateDateTime,
        this.RoleId,
        this.RoleNameEn,
        this.IsResetPassword});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    UserId = json['UserId'].toString().toString();
    TitleId = json['TitleId'].toString().toString();;
    NameEn = json['NameEn'].toString();
    NameHi = json['NameHi'].toString();
    LoginId = json['LoginId'].toString();
    LoginPassword = json['LoginPassword'].toString();
    LoginRecoveryQuestionId = json['LoginRecoveryQuestionId'].toString();
    LoginRecoveryAnswer = json['LoginRecoveryAnswer'].toString();
    GenderId = json['GenderId'].toString();
    UserImagePath = json['UserImagePath'].toString();
    MobileNo = json['MobileNo'].toString();
    LandlineNo = json['LandlineNo'].toString();
    UserEmail = json['UserEmail'].toString();
    UserAddressEn = json['UserAddressEn'].toString();
    Address = json['Address'].toString();
    LastLoginDateTime = json['LastLoginDateTime'].toString();
    LastLoginAttemptDateTime = json['LastLoginAttemptDateTime'].toString();
    NoOfAttempt = json['NoOfAttempt'].toString();
    IsFirstTimeLogin = json['IsFirstTimeLogin'].toString();
    LastLoginAttemptTempDateTime = json['LastLoginAttemptTempDateTime'].toString();
    UserDeactiveDateTime = json['UserDeactiveDateTime'].toString();
    WebsiteId = json['WebsiteId'].toString();
    IsUserActive = json['IsUserActive'].toString();
    IsUserDelete = json['IsUserDelete'].toString();
    CreateBy = json['CreateBy'].toString();
    CreateDateTime = json['CreateDateTime'].toString();
    UpdateBy = json['UpdateBy'].toString();
    RoleId = json['RoleId'].toString();
    RoleNameEn = json['RoleNameEn'].toString();
    IsResetPassword = json['IsResetPassword'].toString();
  }


}