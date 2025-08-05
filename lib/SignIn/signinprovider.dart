  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
  import 'package:optimanage/services/HttpService.dart';
  import 'package:optimanage/constant/Constants.dart';
  import 'package:optimanage/utils/EncryptionHelper.dart';
  import 'dart:math';
  import 'dart:convert';
  import 'package:dio/dio.dart';
  import '../../utils/UtilityClass.dart';
  import 'package:optimanage/models/Maindatamodel.dart';
  import 'package:optimanage/SignIn/UserInfoModel.dart';
  import '../../utils/PrefUtil.dart';
  import 'package:optimanage/constant/colors.dart';
  import 'package:optimanage/utils/RightToLeftRoute.dart';
  import 'package:optimanage/Home/home_screen.dart';
  import 'package:provider/provider.dart';

  import '../Home/home_provider.dart';

  class signinprovider with ChangeNotifier {
    TextEditingController _empIDController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    List<UserInfoModel>? userResponseList = [];

    TextEditingController get empIDController => _empIDController;
    TextEditingController get passwordController => _passwordController;

    bool _isLoading = false;

    bool get isLoading => _isLoading;

    void _setLoading(bool value) {
      _isLoading = value;
      notifyListeners();
    }

    String? validateempIDTextField(String? value) {
      if (value == null || value.isEmpty) {
        return "Please enter Employee ID";
      }
      return null;
    }

    String? validatepasswordTextField(String? value) {
      if (value == null || value.isEmpty) {
        return "Please enter Employee ID";
      }
      return null;
    }


    Future<void> loginUser(BuildContext buildContext) async {
      print("working===working");
      if (_isLoading) return; // Prevent multiple logins

      _setLoading(true); // Set loading state
      try {
        HttpService http = HttpService(Constants.baseurl,buildContext);

        String empId = empIDController.text;
        String pass = passwordController.text;
        Response response = await http
            .getRequest(
            '${Constants.baseurl}${Constants.loginUrl}/$empId/$pass');

        // final List<dynamic> jsonArray = jsonDecode(response.data);
        print("responnnnn=> ${response.data}");
        Maindatamodel? requestModel = Maindatamodel.fromJson(response.data);

        print("stateValue=> ${requestModel.state}");
        if (requestModel.state == 3) {
          bool chekstatus = await UtilityClass.askForInput(
            "Optimanage",
            requestModel.message.toString(),
            "okay",
            "okay",
            true,
          );
          // if (!chekstatus) {
          //   empIDController.text = "";
          //   passwordController.text = "";
          // }
        } else {
          print("Login API response 111111 => ${requestModel.data}");
          await checkAndMoveForward(buildContext, requestModel!.data);
        }
      }catch (e) {
        print("Login error: $e");
        UtilityClass.showSnackBar(buildContext, "Login failed. Please try again.", Colors.red);
      } finally {
        _setLoading(false); // Reset loading state
      }
    }

    checkAndMoveForward(BuildContext buildContext, UserInfoModel? data) async {
      await PrefUtil.setPrefUserId(int.parse(data!.UserId!));
      await PrefUtil.setTitleId(data.TitleId!);
      await PrefUtil.setNameEn(data.NameEn!);
      await PrefUtil.setNameHi(data.NameHi!);
      await PrefUtil.setLoginId(data.LoginId!);
      await PrefUtil.setLoginPassword(data.LoginPassword!);
      await PrefUtil.setLoginRecoveryQuestionId(
          data.LoginRecoveryQuestionId!);
      await PrefUtil.setLoginRecoveryAnswer(
          data.LoginRecoveryAnswer!);
      await PrefUtil.setGenderId(data.GenderId!);
      await PrefUtil.setUserImagePath(data.UserImagePath!);
      await PrefUtil.setMobileNo(data.MobileNo!);
      await PrefUtil.setLandlineNo(data.LandlineNo!);
      await PrefUtil.setUserEmail(data.UserEmail!);
      await PrefUtil.setUserAddressEn(data.UserAddressEn!);
      await PrefUtil.setAddress(data.Address!);
      await PrefUtil.setLastLoginDateTime(
          data.LastLoginDateTime!);
      await PrefUtil.setLastLoginAttemptDateTime(
          data.LastLoginAttemptDateTime!);
      await PrefUtil.setNoOfAttempt(data.NoOfAttempt!);
      await PrefUtil.setIsFirstTimeLogin(data.IsFirstTimeLogin!);
      await PrefUtil.setLastLoginAttemptTempDateTime(
          data.LastLoginAttemptTempDateTime!);
      await PrefUtil.setUserDeactiveDateTime(
          data.UserDeactiveDateTime!);
      await PrefUtil.setWebsiteId(data.WebsiteId!);
      await PrefUtil.setIsUserActive(data.IsUserActive!);
      await PrefUtil.setIsUserDelete(data.IsUserDelete!);
      await PrefUtil.setCreateBy(data.CreateBy!);
      await PrefUtil.setCreateDateTime(data.CreateDateTime!);
      await PrefUtil.setUpdateBy(data.UpdateBy!);
      await PrefUtil.setUpdateDateTime(data.UpdateDateTime.toString());
      await PrefUtil.setRoleId(int.parse(data!.RoleId!));
      await PrefUtil.setRoleNameEn(data.RoleNameEn!);
      await PrefUtil.setIsResetPassword(data.IsResetPassword!);


      await PrefUtil.setUserLoggedWay("true");
      UtilityClass.showSnackBar(
          buildContext, "Login successfully", kPrimaryDark);
      Navigator.of(buildContext).pushAndRemoveUntil(
        RightToLeftRoute(
          page: ChangeNotifierProvider(
            create: (_) => HomeProvider(),
            child: const HomeScreen(),
          ),
          duration: const Duration(milliseconds: 500),
          startOffset: const Offset(1.0, 0.0),
        ),
            (Route<dynamic> route) => false,
      );

      notifyListeners();
    }

    void clearControllers() {
      _empIDController.clear();
      _passwordController.clear();
    }


  }
