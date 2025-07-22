import 'package:shared_preferences/shared_preferences.dart';


class PrefUtil {
  static String UserId ="UserId";
  static String TitleId ="TitleId";
  static String NameEn ="NameEn";
  static String NameHi ="NameHi";
  static String LoginId ="LoginId";
  static String LoginPassword ="LoginPassword";
  static String LoginRecoveryQuestionId ="LoginRecoveryQuestionId";
  static String LoginRecoveryAnswer ="LoginRecoveryAnswer";
  static String GenderId ="GenderId";
  static String UserImagePath ="UserImagePath";
  static String MobileNo ="MobileNo";
  static String LandlineNo ="LandlineNo";
  static String UserEmail ="UserEmail";
  static String UserAddressEn ="UserAddressEn";
  static String Address ="Address";
  static String LastLoginDateTime ="LastLoginDateTime";
  static String LastLoginAttemptDateTime ="LastLoginAttemptDateTime";
  static String NoOfAttempt ="NoOfAttempt";
  static String IsFirstTimeLogin ="IsFirstTimeLogin";
  static String LastLoginAttemptTempDateTime = "LastLoginAttemptTempDateTime";
  static String UserDeactiveDateTime = "UserDeactiveDateTime";
  static String WebsiteId = "WebsiteId";
  static String IsUserActive = "IsUserActive";
  static String IsUserDelete = "IsUserDelete";
  static String CreateBy = "CreateBy";
  static String CreateDateTime = "CreateDateTime";
  static String UpdateBy = "UpdateBy";
  static String UpdateDateTime = "UpdateDateTime";
  static String RoleId = "RoleId";
  static String RoleNameEn = "RoleNameEn";
  static String IsResetPassword = "IsResetPassword";

  static const String USER_LOGGEDIN_WAY = "user_logged_in_way";


  static Future<void> setUserLoggedWay(String userWay) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(USER_LOGGEDIN_WAY, userWay);
  }

  static Future<String?> getUserLoggedWay() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USER_LOGGEDIN_WAY);
  }

  static Future<String?> getUserName() async{
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginPassword);
  }

  static Future setUserName(String userway) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(LoginPassword, userway);
  }

  static Future<String?> getPassword() async{
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginId);
  }

  static Future setPassword(String userway) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(LoginId, userway);
  }


  static Future<void> setPrefUserId(int value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(UserId, value);
  }

  static Future<int?> getPrefUserId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(UserId);
  }


  static Future<String?> getTitleId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(TitleId);
  }

  static Future setTitleId(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(TitleId, value);
  }

  static Future<String?> getNameEn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(NameEn);
  }

  static Future setNameEn(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(NameEn, value);
  }

  static Future<String?> getNameHi() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(NameHi);
  }

  static Future setNameHi(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(NameHi, value);
  }

  static Future<String?> getLoginId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginId);
  }

  static Future setLoginId(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LoginId, value);
  }

  static Future<String?> getLoginPassword() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginPassword);
  }

  static Future setLoginPassword(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LoginPassword, value);
  }

  static Future<String?> getLoginRecoveryQuestionId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginRecoveryQuestionId);
  }

  static Future setLoginRecoveryQuestionId(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LoginRecoveryQuestionId, value);
  }

  static Future<String?> getLoginRecoveryAnswer() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LoginRecoveryAnswer);
  }

  static Future setLoginRecoveryAnswer(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LoginRecoveryAnswer, value);
  }

  static Future<String?> getGenderId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(GenderId);
  }

  static Future setGenderId(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(GenderId, value);
  }

  static Future<String?> getUserImagePath() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UserImagePath,);
  }

  static Future setUserImagePath(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UserImagePath, value);
  }

  static Future<String?> getMobileNo() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(MobileNo);
  }

  static Future setMobileNo(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(MobileNo, value);
  }

  static Future<String?> getLandlineNo() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LandlineNo);
  }

  static Future setLandlineNo(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LandlineNo, value);
  }

  static Future<String?> getUserEmail() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UserEmail);
  }

  static Future setUserEmail(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UserEmail, value);
  }

  static Future<String?> getUserAddressEn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UserAddressEn);
  }

  static Future setUserAddressEn(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UserAddressEn, value);
  }

  static Future<String?> getAddress() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(Address);
  }

  static Future setAddress(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(Address, value);
  }

  static Future<String?> getLastLoginDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LastLoginDateTime);
  }

  static Future setLastLoginDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LastLoginDateTime, value);
  }

  static Future<String?> getLastLoginAttemptDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LastLoginAttemptDateTime);
  }

  static Future setLastLoginAttemptDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LastLoginAttemptDateTime, value);
  }

  static Future<String?> getNoOfAttempt() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(NoOfAttempt);
  }

  static Future setNoOfAttempt(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(NoOfAttempt, value);
  }

  static Future<String?> getIsFirstTimeLogin() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(IsFirstTimeLogin);
  }

  static Future setIsFirstTimeLogin(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(IsFirstTimeLogin, value);
  }

  static Future<String?> getLastLoginAttemptTempDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(LastLoginAttemptTempDateTime);
  }

  static Future setLastLoginAttemptTempDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(LastLoginAttemptTempDateTime, value);
  }

  static Future<String?> getUserDeactiveDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UserDeactiveDateTime);
  }

  static Future setUserDeactiveDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UserDeactiveDateTime, value);
  }

  static Future<String?> getWebsiteId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(WebsiteId);
  }

  static Future setWebsiteId(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(WebsiteId, value);
  }

  static Future<String?> getIsUserActive() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(IsUserActive);
  }

  static Future setIsUserActive(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(IsUserActive, value);
  }

  static Future<String?> getIsUserDelete() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(IsUserDelete);
  }

  static Future setIsUserDelete(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(IsUserDelete, value);
  }

  static Future<String?> getCreateBy() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(CreateBy);
  }

  static Future setCreateBy(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(CreateBy, value);
  }

  static Future<String?> getCreateDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(CreateDateTime);
  }

  static Future setCreateDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(CreateDateTime, value);
  }

  static Future<String?> getUpdateBy() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UpdateBy);
  }

  static Future setUpdateBy(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UpdateBy, value);
  }

  static Future<String?> getUpdateDateTime() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(UpdateDateTime);
  }

  static Future setUpdateDateTime(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(UpdateDateTime, value);
  }

  static Future<void> setRoleId(int value) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(RoleId, value);
  }

  static Future<int?> getRoleId() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(RoleId);
  }

  static Future<String?> getRoleNameEn() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(RoleNameEn);
  }

  static Future setRoleNameEn(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(RoleNameEn, value);
  }

  static Future<String?> getIsResetPassword() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(IsResetPassword);
  }

  static Future setIsResetPassword(String value) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(IsResetPassword, value);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


}
